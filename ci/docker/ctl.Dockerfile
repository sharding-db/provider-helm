
FROM golang:1.18-alpine AS builder

RUN apk add --no-cache git

WORKDIR /go/src/github.com/sharding-db/provider-helm

COPY go.mod go.sum ./
COPY cmd ./cmd
COPY apis  ./apis
COPY pkg  ./pkg
RUN mkdir -p ./bin \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./bin/provider-helm ./cmd/provider 

RUN wget https://github.com/milvus-io/milvus-helm/raw/milvus-4.0.27/charts/milvus/charts/etcd-6.3.3.tgz -P /go/

FROM alpine:3.13

COPY --from=builder /go/src/github.com/sharding-db/provider-helm/bin/provider-helm /usr/bin/provider-helm
COPY --from=builder /go/etcd-6.3.3.tgz /tmp/charts/etcd-6.3.3.tgz

ENV HELM_CACHE_HOME /tmp/helm-cache
ENV HELM_CONFIG_HOME /tmp/helm-config
ENV HELM_DATA_HOME /tmp/helm-data



EXPOSE  8080
USER 65532:65532
ENTRYPOINT ["/usr/bin/provider-helm"]