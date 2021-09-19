#!/bin/bash

##########################################################################################
# SECTION 01: PREPARE ENVIRONMENT LOCALHOST/VAGRANT

# change root
sudo -i
sleep 1

# update system
yum clean all
yum -y update
sleep 1

# config timezone
timedatectl set-timezone Asia/Ho_Chi_Minh

# disable SELINUX
setenforce 0 
sed -i 's/enforcing/disabled/g' /etc/selinux/config

# disable firewall
systemctl stop firewalld
systemctl disable firewalld

##########################################################################################
# SECTION 02: Install dependencies and cluster k8s

# TODO Make [pod network CIDR, K8s version, docker version, etc.] configurable
K8S_VERSION="1.22.1" # K8s is changed regularly. I just want to keep this script stable with v1.22
CALICIO_VERISON="3.17"
POD_IP_RANGE="192.168.0.0/16"  # This IP Range is the default value of Calico
API_SERVER="172.20.10.101"

# check requirements
echo "--> STEP 01. check requirements"
# Tắt swap: Nên tắt swap để kubelet hoạt động ổn định.
sed -i '/swap/d' /etc/fstab
swapoff -a

# install docker
echo "--> STEP 02. install Docker"
if [ ! -d /etc/systemd/system/docker.service.d ]; then

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
 "exec-opts": ["native.cgroupdriver=systemd"],
 "log-driver": "json-file",
 "log-opts": {
 "max-size": "100m"
 },
 "storage-driver": "overlay2",
 "storage-opts": [
   "overlay2.override_kernel_check=true"
 ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
fi

# Install kubelet, kubeadm và kubectl
echo "--> STEP 03. install Kubernetes components"
if [ ! -f /etc/yum.repos.d/kubernetes.repo ]; then
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
yum update -y

# yum install -y -q kubelet kubeadm kubectl --disableexcludes=kubernetes
yum install -y kubeadm-$K8S_VERSION kubelet-$K8S_VERSION kubectl-$K8S_VERSION --disableexcludes=kubernetes

systemctl enable kubelet
systemctl start kubelet

# sysctl
cat >>/etc/sysctl.d/k8s.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

fi

# Install apache
yum install httpd -y
systemctl enable httpd
systemctl start httpd

#########################################################################################
# SECTION 03: CONFIG K8S CLUSTER

# Configure NetworkManager before attempting to use Calico networking.
if [ ! -f /etc/NetworkManager/conf.d/calico.conf ]; then
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF
fi

# Init the cluster
kubeadm init --pod-network-cidr=$POD_IP_RANGE --apiserver-advertise-address=$API_SERVER | tee kubeadm-init.out

# Setup kubectl for user root on Master Node
export KUBECONFIG=/etc/kubernetes/admin.conf
echo 'export KUBECONFIG=/etc/kubernetes/admin.conf' >> ~/.bash_profile

# Install Calico network. Ref. https://docs.projectcalico.org/v3.17/getting-started/kubernetes/installation/calico
kubectl apply -f https://docs.projectcalico.org/v$CALICIO_VERISON/manifests/calico.yaml

# Đến đây Master Node của Kubernetes Cluster đã sẵn sàng,
# cho Worker Node tham gia (join) vào

# Save command to join cluster
sudo kubeadm token create --print-join-command > /var/www/html/join-cluster.sh

# copy config cluster
cp /etc/kubernetes/admin.conf /var/www/html/config
chmod 755 /var/www/html/config

# chúng ta có thể kiểm tra trạng thái của Master Node như sau:
kubectl get nodes

#########################################################################################
# SECTION 04: CONFIG ALLOW DEPLOY POD ON MASTER NODE
# Cho phép pod triển khai trên master
kubectl taint node master-test-01 node-role.kubernetes.io/master-

#########################################################################################
# SECTION 05: DEPOLOY NFS SERVER

# Step 01: INSTALL NFS
echo "INSTALLING NFS"
# Cài đặt nfs
yum install nfs-utils -y

# Step 02: CONFIG
# Chuẩn bị thư mục chia sẻ:
# ví dụ thư mục chia sẻ trên NFS server là /nfs-vol
mkdir /nfs-vol

# tạo file để test
touch /nfs-vol/data-on-server.test

# Thay đổi permission cho thư mục
chmod -R 755 /nfs-vol
chown nfsnobody:nfsnobody /nfs-vol

# Kích hoạt và chạy các dịch vụ cần thiết:

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap

systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

sleep 2

# Thiết lập quyền truy cập (client truy cập được từ một IP cụ thể của Client),
# cập nhật quyền này vào file /etc/exports,
# Ví dụ IP Client 172.16.10.107 có quyền truy cập:

cat >> "/etc/exports" <<END
/nfs-vol    *(rw,sync,no_subtree_check,insecure)
END

#export
exportfs -rav

systemctl restart nfs-server
sleep 2

# Step 03: kiểm tra cấu hình chia sẻ
exportfs -v
showmount -e
echo "INSTALLING NFS FINISHED"
###################




