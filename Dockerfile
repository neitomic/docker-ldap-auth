FROM centos:latest
MAINTAINER Tien Nguyen <thanhtien522@gmail.com>

ENV container docker
RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install openssh-server openldap openldap-clients nss-pam-ldapd authconfig && \
    rm -f /etc/ssh/ssh_*_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -A && \
    sed -i "s/#.*UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/#.*UseDNS.*/UseDNS no/g" /etc/ssh/sshd_config

ADD scripts /root/.scripts
RUN chmod +x /root/.scripts/*.sh

VOLUME [ "/sys/fs/cgroup" ]

EXPOSE 22
CMD ["/root/.scripts/run.sh"]

