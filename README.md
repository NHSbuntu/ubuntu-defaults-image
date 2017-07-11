# About

Build an Ubuntu(/flavor) from a defaults package

Supports Launchpad.net and packagecloud.io

# Usage
```
export LB_ISO_TITLE="NHSbuntu"
export LB_ISO_VOLUME="NHSbuntu xenial $(date +%Y%m%d-%H:%M)"
sudo -E ./ubuntu-defaults-image --package nhsbuntu-default-settings --keep-apt --release xenial --flavor ubuntu-gnome --repo nhsbuntu/nhsbuntu-default-settings
```
