#!/bin/bash
# ref : https://metallb.universe.tf/installation/

# Preparation
# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

# deploy with helm
helm repo add metallb https://metallb.github.io/metallb
helm repo update
kubectl create ns metallb-system
helm install metallb metallb/metallb -n metallb-system -f ./values.yaml