### Manual deployment ingress controller
- depoly using helm

- Step 1: config in values.yaml
```console
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 172.20.10.210-172.20.10.220
```

- Step 2: create namespace metallb-system
```console
kubectl create ns metallb-system
```

- Step 3: install
```
helm install metallb metallb/metallb -n metallb-system -f ./values.yaml
``` 

### Ref
```console
- https://www.youtube.com/watch?v=2SmYjj-GFnE
- https://metallb.universe.tf/installation/
```
