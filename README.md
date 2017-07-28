# NHSbuntu - ubuntu-defaults-image

Builds an ISO of an Ubuntu (/flavor) from a defaults package. This version has added support for repos hosted on packagecloud.io and multiple extra packages.

Based on [ubuntu-defaults-builder](https://launchpad.net/ubuntu/xenial/+package/ubuntu-defaults-builder) by Martin Pitt.

## Getting started

Basic usage follows the manpage for the source package. Here's an example using the NHSbuntu PPA and defaults settings package.

```
./ubuntu-defaults-image --ppa nhsbuntu/ppa --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings
```

Specify a repository on packagecloud.io with `--repo organisation/reponame`

```
./ubuntu-defaults-image --repo nhsbuntu/nhsbuntu-default-settings --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings
```

Specify additional PPAs with `--ppa name/ppa`

```
./ubuntu-defaults-image --repo nhsbuntu/nhsbuntu-default-settings --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings --ppa libreoffice/ppa
```

Specify additional packages `--xpackage packagename`

```
./ubuntu-defaults-image --repo nhsbuntu/nhsbuntu-default-settings --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings --ppa libreoffice/ppa --xpackage libreoffice-style-breeze
```

## Create NHSbuntu ISOs - command line

Included is the NHSbuntu build helper `build.sh`, a wrapper for ubuntu-defaults-image. You can use this script to create the NHSbuntu ISOs for yourself. It is the same script used by Travis CI to automagically create the NHSbuntu ISOs.

### Usage

To create 64bit ISO

    sudo -E BUILDARCH=amd64 ./build.sh

To create 32bit ISO

    sudo -E BUILDARCH=i386 ./build.sh

### Our patch to live-build

The helper script `build.sh` patches the live-build configuration file `lb_binary_disk` to use the variable `$LB_ISO_VOLUME` for `.disk/info` during the finalisation of the ISO images.

## Create NHSbuntu ISOs - Dockerised

You can use our Docker container to build NHSbuntu ISOs.

```
docker pull nhsbuntu/ubuntu-defaults-image:latest
docker run --env BUILDARCH=amd64 --rm -it -v `pwd`:`pwd` -w `pwd` --name buildamd64 --privileged nhsbuntu/ubuntu-defaults-image /bin/bash -c "./build.sh"
docker run --env BUILDARCH=i386 --rm -it -v `pwd`:`pwd` -w `pwd` --name buildi386 --privileged nhsbuntu/ubuntu-defaults-image /bin/bash -c "./build.sh"
```

## Travis CI [![Build Status](https://travis-ci.org/NHSbuntu/ubuntu-defaults-image.svg?branch=master)](https://travis-ci.org/NHSbuntu/ubuntu-defaults-image)

In the small hours of the morning Travis gets busy building NHSbuntu ISOs for us.

## Authors

- [Rob Dyke](https://github.com/robdyke) - added support for _packagecloud.io_ and _extra packages_.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3. See the LICENSE file for details.

## Acknowledgments

- Based on [ubuntu-defaults-builder](https://launchpad.net/ubuntu/xenial/+package/ubuntu-defaults-builder) by Martin Pitt.
