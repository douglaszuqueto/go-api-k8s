dev:
	go run main.go

build:
	CGO_ENABLED=0
	go build -ldflags "${XFLAGS} -s -w" -o bin/go-api-k8s main.go

deploy: docker k8s-apply

docker-build:
	docker build -t douglaszuqueto/go-api-k8s .

docker-push:
	docker push douglaszuqueto/go-api-k8s

docker-run:
	docker run -it --rm -p 4000:4000 douglaszuqueto/go-api-k8s

docker: docker-build docker-push

k8s-apply:
	kubectl apply -f ./k8s/deployment.yml -f ./k8s/svc.yml

k8s-delete:
	kubectl delete -f ./k8s/deployment.yml -f ./k8s/svc.yml

.PHONY: dev build deploy docker-build docker-push docker k8s-apply k8s-delete