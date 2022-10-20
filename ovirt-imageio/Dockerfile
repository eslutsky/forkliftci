FROM quay.io/centos/centos:stream8

RUN dnf install centos-release-ovirt45 -y
RUN dnf install ovirt-imageio-daemon ovirt-imageio-common ovirt-imageio-client -y

EXPOSE 12345

COPY myticket.json myticket.json
COPY 99-cdi.conf /etc/ovirt-imageio/conf.d/99-cdi.conf
COPY cirros.raw /images/cirros.raw
COPY server.key /tmp/certs/tls.key
COPY imageio.crt /tmp/certs/tls.crt

WORKDIR /

#CMD ovirt-imageio& sleep 15 && ovirt-imageioctl add-ticket myticket.json && tail -n+1 -f /var/log/ovirt-imageio/daemon.log
