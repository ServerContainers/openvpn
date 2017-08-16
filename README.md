# Docker OpenVPN (servercontainers/openvpn)
_maintained by ServerContainers_

[FAQ - All you need to know about the servercontainers Containers](https://marvin.im/docker-faq-all-you-need-to-know-about-the-marvambass-containers/)

## What is it

This Dockerfile (available as ___servercontainers/openvpn___) gives you a openvpn server.

It's based on the [_/debian:jessie](https://registry.hub.docker.com/_/debian/) Image

View in Docker Registry [servercontainers/mail-box](https://registry.hub.docker.com/u/servercontainers/openvpn/)

View in GitHub [ServerContainers/mail-box](https://github.com/ServerContainers/openvpn)

## Environment variables

_currently no available_

## Ports

- 1194
    - default OpenVPN Port

## Volumes

- /etc/openvpn
    - this is where the container looks for:
        - config.ovpn (openvpn server configuration)
        - crl.pem (certificate revocation list - if specified in server configuration)

## Example Server Configuration

_replace ASDF with the certificate data_

```
proto udp
dev tun
persist-tun
persist-key
port 1194
<dh>
-----BEGIN DH PARAMETERS-----
ASDFASDF
-----END DH PARAMETERS-----
</dh>
crl-verify crl.pem
management localhost 7505
keepalive 10 120
ifconfig-pool-persist openvpn-ipp.txt
status openvpn-status.log
status-version 2
verb 0
user nobody
group nogroup
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DOMAIN localnet.lan"
push "dhcp-option DNS 8.8.8.8"
server 10.8.0.0 255.255.255.0
comp-lzo
<ca>
-----BEGIN CERTIFICATE-----
ASDFASDF
-----END CERTIFICATE-----
</ca>
<key>
-----BEGIN PRIVATE KEY-----
ASDFASDF
-----END PRIVATE KEY-----
</key>
<cert>
-----BEGIN CERTIFICATE-----
ASDFASDF
-----END CERTIFICATE-----
</cert>
```
