#!/bin/bash
# ref https://kubernetes.github.io/ingress-nginx/deploy/#using-helm

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create ns ingress-nginx
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx -f ./values.yaml
