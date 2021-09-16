#!/bin/bash
# ref https://kubernetes.github.io/ingress-nginx/deploy/#using-helm

kubectl create ns ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx -f ./values.yaml
