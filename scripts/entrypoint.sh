#!/bin/sh

# only on container creation
INITIALIZED="/.initialized"
if [ ! -f "$INITIALIZED" ]; then
	touch "$INITIALIZED"

  ###
  # RUNIT
  ###

  echo ">> RUNIT - create services"
  mkdir -p /etc/sv/rsyslog /etc/sv/openvpn
  echo '#!/bin/sh\nexec /usr/sbin/rsyslogd -n' > /etc/sv/rsyslog/run
    echo '#!/bin/sh\nrm /var/run/rsyslogd.pid' > /etc/sv/rsyslog/finish
  echo '#!/bin/sh\ncd /etc/openvpn\nexec /usr/sbin/openvpn --config config.ovpn' > /etc/sv/openvpn/run
  chmod a+x /etc/sv/*/run /etc/sv/*/finish

  echo ">> RUNIT - enable services"
  ln -s /etc/sv/openvpn /etc/service/openvpn
  ln -s /etc/sv/rsyslog /etc/service/rsyslog

  mkdir -p /dev/net
  if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
  fi

  ip -6 route show default 2>/dev/null
  if [ $? = 0 ]; then
    echo "Enabling IPv6 Forwarding"
    # If this fails, ensure the docker container is run with --privileged
    # Could be side stepped with `ip netns` madness to drop privileged flag

    sysctl -w net.ipv6.conf.all.disable_ipv6=0 || echo "Failed to enable IPv6 support"
    sysctl -w net.ipv6.conf.default.forwarding=1 || echo "Failed to enable IPv6 Forwarding default"
    sysctl -w net.ipv6.conf.all.forwarding=1 || echo "Failed to enable IPv6 Forwarding"
  fi

fi

/bin/bash -c 'sleep 5
    echo ">> update firewall settings"
    iptables -A FORWARD -o eth0 -i tun0 -s 10.8.0.0/24 -m conntrack --ctstate NEW -j ACCEPT
    iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE' &

echo ">> starting services"
exec runsvdir -P /etc/service
