### Manual deployment ingress controller ambassador
- depoly using helm

- Step 1: config in values.yaml
```console
hostNetwork: true
hostPort:
    enabled: true
kind: DaemonSet
```

- Step 2: create namespace ingress-nginx
```console
kubectl create ns ingress-nginx
```

- Step 3: install ingerss controller
```
helm install myingress ingress-nginx/ingress-nginx -n ingress-nginx -f ./values.yaml
``` 

### Result

### Ref
```console
- https://www.youtube.com/watch?v=PCMdUj5kGHU
- https://www.learncloudnative.com/blog/2020-06-24-ssl-ambassador-lets-encrypt
- https://www.getambassador.io/docs/edge-stack/latest/howtos/cert-manager/

```
