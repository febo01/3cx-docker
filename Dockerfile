FROM fbarbier01/debian-systemd
CMD ["/lib/systemd/systemd"]
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LANG en_US.UTF-8
ENV TERM xterm
ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND noninteractive
ENV DBUS_SESSION_BUS_ADDRESS unix:path=/run/user/0/bus

RUN apt-get update \
    && apt-get install -y sudo wget nano net-tools gpg openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get install curl net-tools tshark sngrep mtr davfs2 dphys-swapfile getent iptables-persistent -y \
    && iptables -t mangle -A OUTPUT -p udp -j DSCP --set-dscp 56 \
    && iptables -t mangle -A OUTPUT -p tcp -j DSCP --set-dscp 56 \
    && iptables-save >> /etc/iptables/rules.v4 \
    && getent hosts sip-slb-cola.voicemeup.com >> /etc/hosts \
    && getent hosts sip-slb-tobo.voicemeup.com >> /etc/hosts \
    && getent hosts tor.trk.tprm.ca >> /etc/hosts \
    && getent hosts edm.trk.tprm.ca >> /etc/hosts \
    && wget -O- http://downloads-global.3cx.com/downloads/3cxpbx/public.key | sudo apt-key add - \
    && echo "deb http://downloads-global.3cx.com/downloads/debian stretch main" | sudo tee /etc/apt/sources.list.d/3cxpbx.list \
    && apt-get update   \

RUN sed -ie 's/#Port/Port/g' /etc/ssh/sshd_config \
	&& sed -ie 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config \
	&& sed -ie 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config \
	&& sed -ie 's/#X11Forwarding/X11Forwarding yes/g' /etc/ssh/sshd_config \
	&& sed -ie 's/#X11DisplayOffset 10/X11DisplayOffset 10/g' /etc/ssh/sshd_config \
  && systemctl restart ssh sshd

EXPOSE 5000 5001 5060 5065 5090 9000

VOLUME [ "/sys/fs/cgroup:/sys/fs/cgroup:ro" ]
