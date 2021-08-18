FROM cern/slc6-base
MAINTAINER David Laube <dlaube@packet.net>
LABEL Description="Packet's Scientific Linux 6 OS base image" Vendor="Packet.net" Version="1.0"

RUN mv /etc/yum.repos.d/epel.repo /epel.repo.bkpi && yum install ${YUM_OPTS} -y \
	bash \
	bash-completion \
	ca-certificates \
	cron \
	curl \
	device-mapper-multipath \
	dmidecode \
	e2fsprogs \
	ethstatus \
	grub \
	grubby \
	ioping \
	iotop \
	iperf \
	iscsi-initiator-utils \
	libmlx4-static \
	libselinux-python \
	make \
	mdadm \
	mg \
	mtr \
	net-tools \
	ntp \
	ntpdate \
	openssh-server \
	policycoreutils-python \
	python-argparse \
	python-cheetah \
	python-configobj \
	python-requests \
	PyYAML \
	redhat-lsb-core \
	rsync \
	screen \
	socat \
	sudo \
	sysstat \
	tar \
	tcpdump \
	tmux \
	traceroute \
	vim \
	wget \
	&& yum clean all

RUN yum --enablerepo=elrepo-kernel install -y kernel
# Add cloud-init and external deps from RPM
RUN rpm -ivh http://ftp.scientificlinux.org/linux/scientific/obsolete/6x/external_products/rh-common/x86_64/python-prettytable-0.6.1-1.el6.noarch.rpm
RUN rpm -ivh http://ftp.scientificlinux.org/linux/scientific/obsolete/6x/external_products/rh-common/x86_64/python-boto-2.6.0-1.el6.noarch.rpm
RUN rpm -ivh http://ftp.scientificlinux.org/linux/scientific/obsolete/6x/external_products/rh-common/x86_64/cloud-init-0.7.2-2.el6.noarch.rpm

# Remove default network iface
RUN rm -f /etc/sysconfig/network-scripts/ifcfg-eth0
RUN cat /etc/udev/rules.d/70-persistent-net.rules | head -6 > /etc/udev/rules.d/70-persistent-net.rules.tmp ; mv -f /etc/udev/rules.d/70-persistent-net.rules.tmp /etc/udev/rules.d/70-persistent-net.rules

# Adjust root account
RUN passwd -d root && passwd -l root

# vim: set tabstop=4 shiftwidth=4:
RUN yum -y install git
