# Script to deploy ingress-nginx-conttoler
# Ref: https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx

#!/bin/sh
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress ingress-nginx/ingress-nginx