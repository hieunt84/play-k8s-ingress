### Manual deployment ingress controller nginx
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
```console
NAME: test
LAST DEPLOYED: Sun Sep 12 09:50:13 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The ingress-nginx controller has been installed.
It may take a few minutes for the LoadBalancer IP to be available.
You can watch the status by running
kubectl --namespace default get services -o wide -w test-ingress-nginx-controller

An example Ingress that makes use of the controller:

  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class:
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /
    # This section is only required if TLS is to be enabled for the Ingress
    tls:
        - hosts:
            - www.example.com
          secretName: example-tls

If TLS is enabled for the Ingress, a Secret containing the certificate and key must also be provided:

  apiVersion: v1
  kind: Secret
  metadata:
    name: example-tls
    namespace: foo
  data:
    tls.crt: <base64 encoded cert>
    tls.key: <base64 encoded key>
  type: kubernetes.io/tls
```

### Ref
```console
- https://www.youtube.com/watch?v=UvwtALIb2U8&t=426s
- https://kubernetes.github.io/ingress-nginx/deploy/#using-helm
```
