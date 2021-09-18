#!/bin/bash
# ref https://artifacthub.io/packages/helm/datawire/ambassador
# ref https://www.getambassador.io/docs/emissary/latest/topics/install/helm/

helm repo add datawire https://getambassador.io
helm repo update
kubectl create namespace ambassador
kubectl config set-context --current --namespace ambassador
helm install ambassador datawire/ambassador -n ambassador -f ./values.yaml --set enableAES=false 