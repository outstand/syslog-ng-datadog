FROM alpine:latest
LABEL maintainer="Ryan Schlesinger <ryan@outstand.com>"

RUN apk add --no-cache bash syslog-ng ca-certificates

COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["syslog-ng", "-F"]
ENTRYPOINT ["/docker-entrypoint.sh"]
