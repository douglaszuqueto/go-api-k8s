#  BASE
FROM golang:alpine as base
WORKDIR /app
COPY go.mod .
COPY go.sum .
RUN go mod download

# BUILDER
FROM base as builder
COPY . .
RUN CGO_ENABLED=0 go build -ldflags "${XFLAGS} -s -w" -a -o api ./main.go

# UPX
FROM douglaszuqueto/alpine-upx as upx
WORKDIR /app
COPY --from=builder /app/api /app
RUN upx /app/api

# FINAL
FROM douglaszuqueto/alpine-go
WORKDIR /app
COPY --from=upx /app/api /app
CMD ["./api"]