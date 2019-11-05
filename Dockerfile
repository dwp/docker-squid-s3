# Builds a docker image for Squid with config retrieved from S3

FROM alpine:3.10

ENV USER_NAME=squid
ENV GROUP_NAME=squid

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache squid python py-pip \
    && pip install awscli

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 0755 /sbin/entrypoint.sh

RUN install -d -m 0755 -o squid -g squid \
    /var/cache/squid /var/log/squid /var/run/squid

RUN chown ${USER_NAME}:${GROUP_NAME} /etc/squid/squid.conf

RUN install -d -m 0755 -o ${USER_NAME} -g ${GROUP_NAME} /etc/squid/conf.d

RUN touch /var/run/squid.pid

RUN chown ${USER_NAME}:${GROUP_NAME} /var/run/squid.pid
RUN chmod 0644 /var/run/squid.pid
RUN chown ${USER_NAME}:${GROUP_NAME} /etc/squid

EXPOSE 3128/tcp

USER ${USER_NAME}

ENTRYPOINT ["/sbin/entrypoint.sh"]
