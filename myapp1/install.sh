#!/bin/bash
# deploy
kubectl create ns myapp1
kubectl config set-context --current --namespace myapp1
kubectl apply -f ./1.app-test.yaml 
kubectl apply -f ./2.app-test-ingerss.yaml
