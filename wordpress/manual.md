### Manual deployment
1. Step 01: config in values.yaml
```
ingress:
  enable: true
  ingressClassName: "nginx"
  tls: true

persistence:
  enabled: true
  storageClass: "nfs-client"
  accessModes:
    - ReadWriteOnce

mariadb:
  enabled: true

...
```

2. Step 02: create namespace wordpress-test
```
kubectl create ns wordpress-test
```

3. Step 03: Install
```
helm install metallb metallb/metallb -n wordpress-test -f ./values.yaml
``` 

