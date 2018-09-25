FROM golang:1.10.3-alpine3.7 as builder
RUN \
    cd / && \
    apk update && \
    apk add --no-cache git ca-certificates make tzdata

COPY . /prometheus_bot
WORKDIR /
RUN \
    cd prometheus_bot && \
    go get -d -v && \
    CGO_ENABLED=0 GOOS=linux go build -v -a -installsuffix cgo -o prometheus_bot 

FROM alpine:3.7
COPY --from=builder /prometheus_bot /
RUN apk add --no-cache ca-certificates tzdata
VOLUME data
EXPOSE 9087
ENTRYPOINT ["/prometheus_bot"]
