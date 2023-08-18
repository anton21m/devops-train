FROM alpine:3.18.3

RUN apk add --no-cache curl

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]