FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q -y update \
 && apt-get -q -y install runit \
                          telnet \
                          rsyslog \
                          iptables \
                          openvpn \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 \
 && head -n $(grep -n RULES /etc/rsyslog.conf | cut -d':' -f1) /etc/rsyslog.conf > /etc/rsyslog.conf.new \
 && mv /etc/rsyslog.conf.new /etc/rsyslog.conf \
 && echo '*.*        /dev/stdout' >> /etc/rsyslog.conf \
 && sed -i 's/.*imklog.so.*//g' /etc/rsyslog.conf \
 \
 && rm -rf /etc/openvpn/*

VOLUME ["/etc/openvpn"]
EXPOSE 1194/udp

COPY scripts /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
