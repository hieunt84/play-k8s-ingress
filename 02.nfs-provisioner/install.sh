#!/bin/bash
# install nfs-provisioner

# add reop
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# install
kubectl create ns nsf-provisioner
kubectl config set-context --current --namespace default
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  -n nsf-provisioner
  --set nfs.server=172.20.10.101\
  --set nfs.path=/nfs-vol

# Testing
kubectl apply -n nsf-provisioner -f ./test-pvc.yaml
