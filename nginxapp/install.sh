#!/bin/bash
# deploy
kubectl create ns nginxapp
kubectl config set-context --current --namespace nginxapp
kubectl apply -f ./1.deployment.yaml 
kubectl apply -f ./2.service.yaml
kubectl apply -f ./3.ingress.yaml

