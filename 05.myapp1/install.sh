#!/bin/bash
# deploy
kubectl create ns myapp1
kubectl config set-context --current --namespace myapp1
kubectl apply -f ./1.deployment.yaml 
kubectl apply -f ./2.service.yaml
kubectl apply -f ./4.ingress-ssl.yaml

