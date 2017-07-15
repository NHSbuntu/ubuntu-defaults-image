FROM ubuntu:16.04
MAINTAINER Rob Dyke <robdyke@gmail.com>

RUN apt-get update ||true
RUN apt-get install --yes curl git live-build cdebootstrap ubuntu-defaults-builder syslinux-utils genisoimage memtest86+ syslinux syslinux-themes-ubuntu-xenial gfxboot-theme-ubuntu livecd-rootfs
RUN git clone https://github.com/robdyke/ubuntu-defaults-image-rd.git
WORKDIR /ubuntu-defaults-image-rd
