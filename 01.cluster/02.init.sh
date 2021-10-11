#!/bin/sh

# Setup Aliases
cat >>/root/.bash_profile<<EOF
# Setup Aliases
alias k='kubectl'
alias ns='kubectl config set-context --current --namespace'
alias kurrent='kubectl config view --minify -o "jsonpath={..namespace}" | xargs -I %s echo "Current Namespace: %s"'
alias nodetop='k get nodes | grep Ready | cut -d" " -f1 | xargs kubectl describe node | grep -E "Name: |cpu |memory "'  

# Setup helm
PATH=$PATH:/usr/local/bin
export PATH
EOF

source /root/.bash_profile

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Xóa taint trên node cho phép tạo Pod
kubectl taint node k8s-vm node-role.kubernetes.io/master-


