# NHSbuntu - ubuntu-defaults-image

Builds an ISO of Ubuntu (/flavor) from a defaults package with added support for repos hosted on packagecloud.io. Based on [ubuntu-defaults-builder](https://launchpad.net/ubuntu/xenial/+package/ubuntu-defaults-builder) by Martin Pitt.

## Getting started

Basic usage follows the manpage for the source package. Here's an example using the NHSbuntu PPA and defaults settings package.

    ./ubuntu-defaults-image --ppa nhsbuntu/ppa --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings

Specify a repository on packagecloud.io with ```--repo organisation/reponame```
```
./ubuntu-defaults-image --repo nhsbuntu/nhsbuntu-default-settings --release xenial --flavor ubuntu-gnome --package nhsbuntu-default-settings
```

## Create NHSbuntu ISOs - command line
Included is the NHSbuntu build helper `build.sh`, a wrapper for ubuntu-defaults-image. You can use this script to create the NHSbuntu ISOs for yourself. It is the same script used by Travis CI to automagically create the NHSbuntu ISOs.

### Usage
To create 64bit ISO `BUILDARCH=amd64 ./build.sh`

To create 32bit ISO `BUILDARCH=i386 ./build.sh`

### Our patch to live-build
The build.sh patches the live-build configuration file `lb_binary_disk` to use the variable `$LB_ISO_VOLUME` for `.disk/info` during the finalisation of the ISO images.

## Create NHSbuntu ISOs - Dockerised
You can use our Docker container to build NHSbuntu ISOs.

    docker pull nhsbuntu/ubuntu-defaults-image:latest
    docker run --env BUILDARCH=amd64 --rm -it -v `pwd`:`pwd` -w `pwd` --name buildamd64 --privileged nhsbuntu/ubuntu-defaults-image /bin/bash -c "./build.sh"
    docker run --env BUILDARCH=i386 --rm -it -v `pwd`:`pwd` -w `pwd` --name buildi386 --privileged nhsbuntu/ubuntu-defaults-image /bin/bash -c "./build.sh"

## Travis CI [![Build Status](https://travis-ci.org/NHSbuntu/ubuntu-defaults-image.svg?branch=master)](https://travis-ci.org/NHSbuntu/ubuntu-defaults-image)

In the small hours of the morning Travis gets busy building NHSbuntu ISOs for us.

## Authors

* [Rob Dyke](https://github.com/robdyke) - *packagecloud.io support*

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

* Based on [ubuntu-defaults-builder](https://launchpad.net/ubuntu/xenial/+package/ubuntu-defaults-builder) by Martin Pitt.
