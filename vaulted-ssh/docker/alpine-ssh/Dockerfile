FROM alpine:3.8

ADD entrypoint.sh /
RUN apk update && apk upgrade && apk add dumb-init curl openssh \
&& chmod +x /entrypoint.sh \
&& mkdir -p /root/.ssh \
&& rm -rf /var/cache/apk/* /tmp/*

EXPOSE 22
VOLUME ["/etc/ssh"]
ENTRYPOINT ["/entrypoint.sh"]
