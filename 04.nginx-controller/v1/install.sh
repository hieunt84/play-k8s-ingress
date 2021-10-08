#!/bin/bash
# ref https://kubernetes.github.io/ingress-nginx/deploy/#using-helm

# add repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# install
kubectl create ns ingress-nginx
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx
