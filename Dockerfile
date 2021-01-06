FROM debian:buster
MAINTAINER Aleksandr Nesterenko <anesterenko@cloudlinux.com>
LABEL Description="Packet's Debian buster OS base image" Vendor="Packet.net" Version="1.0"

# Setup the environment
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get -q update && \
    apt-get -y -qq upgrade && \
    apt-get -y -qq install \
		apt-transport-https \
		bash \
		bash-completion \
		bc \
		ca-certificates \
		cloud-init \
		jq \
		cron \
		curl \
		dbus \
		dialog \
		dstat \
		ethstatus \
		file \
		fio \
		haveged \
		htop \
		ifenslave \
		ioping \
		initramfs-tools \
		iotop \
		iperf \
		iptables \
		iputils-ping \
		less \
		libmlx5-1 \
		locales \
		locate \
		lsb-release \
		lsof \
		make \
		man-db \
		mdadm \
		mg \
		mosh \
		mtr \
		multipath-tools \
		nano \
		net-tools \
		netcat \
		nmap \
		ntp \
		ntpdate \
		open-iscsi \
		python-apt \
		python-yaml \
		rsync \
		rsyslog \
		screen \
		shunit2 \
		socat \
		software-properties-common \
		ssh \
		sudo \
		sysstat \
		systemd-sysv \
		tar \
		tcpdump \
		tmux \
		traceroute \
		unattended-upgrades \
		uuid-runtime \
		vim \
		wget

# Install a specific kernel
RUN apt-get -q update && \
    apt-get -y -qq install \
    linux-image-4.19.0-12-amd64 \
    && apt-get -y remove --purge linux-image-4.19.0-12-amd64-dbg

RUN apt-get -q -y install xen-system-amd64 xen-tools
RUN dpkg-divert --divert /etc/grub.d/08_linux_xen --rename /etc/grub.d/20_linux_xen
RUN cp /etc/network/interfaces /etc/network/interfaces.backup
RUN echo "iface xenbr0 inet static" >> /etc/network/interfaces && echo "	bridge_ports bond0" >> /etc/network/interfaces && \
    echo "	address 147.75.50.154" >> /etc/network/interface && echo "	netmask 255.255.255.254" >> /etc/network/interfaces && \
    echo "	gateway 147.75.50.152" >> /etc/network/interface

# Assign default target
RUN systemctl set-default multi-user

# Enable update-motd.d support
RUN rm -f /etc/motd && ln -s /var/run/motd /etc/motd

# Configure locale
RUN echo "Etc/UTC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

# Configure Systemd
RUN systemctl disable \
	systemd-modules-load.service \
	systemd-update-utmp-runlevel \
	proc-sys-fs-binfmt_misc.automount \
	kmod-static-nodes.service

# Replace init with systemd
RUN rm -f /sbin/init \
	&& ln -sf ../lib/systemd/systemd /sbin/init

# Fix perms
RUN chmod 755 /etc/default

# Clean APT cache
RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*

# vim: set tabstop=4 shiftwidth=4:
