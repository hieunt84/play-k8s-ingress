#!/bin/bash
# ref https://artifacthub.io/packages/helm/datawire/ambassador

helm repo add datawire https://getambassador.io
helm repo update
kubectl create namespace ambassador
helm install ambassador datawire/ambassador -n ambassador -f ./values.yaml
