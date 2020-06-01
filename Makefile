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

release:
	@ if [ "$(VERSION)" = "" ]; then \
        echo "Version not set"; \
        exit 1; \
    fi

	@echo New release: $(VERSION)

	docker build -t douglaszuqueto/go-api-k8s:$(VERSION) --build-arg version=$(VERSION) .

	docker push douglaszuqueto/go-api-k8s:$(VERSION)

loop:
	@ while true; do \
    	curl "http://192.168.0.10:5000/"; \
    	echo -e ""; \
    	sleep 1; \
	done

.PHONY: dev build deploy docker-build docker-push docker k8s-apply k8s-delete release