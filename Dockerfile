# Builds a docker image for Squid with config retrieved from S3

FROM alpine:3.9

RUN apk add --update squid python py-pip && \
    pip install awscli
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 0755 /sbin/entrypoint.sh
RUN ln -sf /dev/stdout /var/log/squid/access.log
EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
