#!/usr/bin/env bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
kubectl create ns wordpress-test
helm install wp-test bitnami/wordpress -n wordpress-test -f values.yaml
