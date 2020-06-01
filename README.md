# API em Go para rodar em clusters K8S

API em Go para utilização em laboratório de estudos K8S

## Tecnologias utilizadas

* Fiber

## Docker Hub

https://hub.docker.com/repository/docker/douglaszuqueto/go-api-k8s

### Tags

Tags disponiveis para testes:

* latest
* v1.0.0
* v1.0.1
* v2.0.0
* v2.0.1

```bash
docker pull docker pull douglaszuqueto/go-api-k8s:latest
docker pull docker pull douglaszuqueto/go-api-k8s:v1.0.0
docker pull docker pull douglaszuqueto/go-api-k8s:v2.0.0
```

## Endpoints

* Ping
* Info
* Env

### Ping

Request: /ping

```bash
curl http://127.0.0.1:4000/ping
```

Response:

```bash
pong
```

### Info

Request: /info

```bash
curl http://127.0.0.1:4000/info
```

Response:

```json
{
  "API_VERSION": "v1.0.0",
  "NODE_NAME": "server",
  "POD_NAME": "doks-api-59d7c46775-p8d7m",
  "HOSTNAME": "fedora"
}
```

### Env

Request: /env

```bash
curl http://127.0.0.1:4000/env
```

Response:

```json
{
  "   ": "/app/api",
  "DOKS_API_PORT": "tcp://10.43.197.32:5000",
  "DOKS_API_PORT_5000_TCP": "tcp://10.43.197.32:5000",
  "DOKS_API_PORT_5000_TCP_ADDR": "10.43.197.32",
  "DOKS_API_PORT_5000_TCP_PORT": "5000",
  "DOKS_API_PORT_5000_TCP_PROTO": "tcp",
  "DOKS_API_SERVICE_HOST": "10.43.197.32",
  "DOKS_API_SERVICE_PORT": "5000",
  "DOKS_API_SERVICE_PORT_TCP_5000_4000": "5000",
  "HOME": "/root",
  "HOSTNAME": "doks-api-59d7c46775-p8d7m",
  "KUBERNETES_PORT": "tcp://10.43.0.1:443",
  "KUBERNETES_PORT_443_TCP": "tcp://10.43.0.1:443",
  "KUBERNETES_PORT_443_TCP_ADDR": "10.43.0.1",
  "KUBERNETES_PORT_443_TCP_PORT": "443",
  "KUBERNETES_PORT_443_TCP_PROTO": "tcp",
  "KUBERNETES_SERVICE_HOST": "10.43.0.1",
  "KUBERNETES_SERVICE_PORT": "443",
  "KUBERNETES_SERVICE_PORT_HTTPS": "443",
  "NODE_NAME": "server",
  "PATH": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "POD_NAME": "doks-api-59d7c46775-p8d7m"
}
```

## Deployment

Nos tópicos abaixo, segue algumas maneiras de realizar o teste/deploy da API

### Docker

Rodando a API no Docker:

```bash
docker run -it --rm --name go-api-k8s -p 4000:4000 douglaszuqueto/go-api-k8s:latest
```

### K8S

Deployment

```yml
kind: Deployment
apiVersion: apps/v1
metadata:
  name: go-api-k8s
  labels:
    k8s-app: go-api-k8s
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: go-api-k8s
  template:
    metadata:
      name: go-api-k8s
      labels:
        k8s-app: go-api-k8s
    spec:
      containers:
        - name: go-api-k8s
          image: douglaszuqueto/go-api-k8s
          imagePullPolicy: IfNotPresent
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
          resources:
            requests:
              cpu: 200m
      restartPolicy: Always
```

Service

```yml
kind: Service
apiVersion: v1
metadata:
  name: go-api-k8s
  namespace: default
  labels:
    k8s-app: go-api-k8s
spec:
  ports:
    - name: tcp-5000-4000
      protocol: TCP
      port: 5000
      targetPort: 4000
  selector:
    k8s-app: go-api-k8s
  type: LoadBalancer
      
```

```bash
kubectl apply -f ./k8s/deployment.yml
kubectl apply -f ./k8s/svc.yml
```