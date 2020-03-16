# Builds a docker image for Squid with config retrieved from S3

FROM alpine:3.11 AS BASE

RUN apk update \
    && apk upgrade

FROM BASE AS PYTHON3
# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

FROM PYTHON3 AS SQUID

ENV USER_NAME=squid
ENV GROUP_NAME=squid
ENV AWSCLI_VERSION="1.17.10-r0"

RUN apk add --update squid

FROM SQUID AS AWSCLI

RUN pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org awscli  --user

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
