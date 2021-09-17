#!/bin/bash
# deploy
kubectl create ns myapp2
kubectl config set-context --current --namespace myapp2
kubectl apply -f ./1.deployment.yaml 
kubectl apply -f ./2.service.yaml
kubectl apply -f ./3.ingress.yaml

