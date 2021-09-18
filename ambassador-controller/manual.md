### Manual deployment ingress controller ambassador
1. Step 01 : add repo
```
helm repo add datawire https://getambassador.io
helm repo update
helm show values datawire/ambassador > values.yaml
```

2. Step 02: config in values.yaml
```
replicaCount: 
daemonSet:
```

3. Step 03: install
```
kubectl create namespace ambassador
helm install ambassador datawire/ambassador -n ambassador -f ./values.yaml
``` 

### Result

### Ref
```
- https://www.youtube.com/watch?v=PCMdUj5kGHU
- https://artifacthub.io/packages/helm/datawire/ambassador
- https://www.learncloudnative.com/blog/2020-06-24-ssl-ambassador-lets-encrypt
- https://www.getambassador.io/docs/edge-stack/latest/howtos/cert-manager/

```
