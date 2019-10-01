# Builds a docker image for Squid with config retrieved from S3

FROM alpine:3.10

RUN apk add --update squid python py-pip && \
    pip install awscli
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 0755 /sbin/entrypoint.sh
RUN install -d -m 0755 -o squid -g squid \
    /var/cache/squid /var/log/squid /var/run/squid
RUN chown squid:squid /etc/squid/squid.conf
RUN install -d -m 0755 -o squid -g squid /etc/squid/conf.d
RUN touch /var/run/squid.pid
RUN chown squid:squid /var/run/squid.pid
RUN chmod 0644 /var/run/squid.pid
EXPOSE 3128/tcp

USER squid
ENTRYPOINT ["/sbin/entrypoint.sh"]
