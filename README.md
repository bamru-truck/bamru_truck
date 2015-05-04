# Bamru Truck Wifi Hotspot

This guide assumes you've got an Ubuntu laptop with an SD card reader/writer,
and a RPi2 with a USB-WIFI device that runs in master mode.

## New RPi Setup

1) load Raspian onto a SD card

https://www.raspberrypi.org/documentation/installation/installing-images/README.md

2) boot the new RPi

3) set the passwd of the 'pi' user to 'pi'

4) enable SSH on the RPi

5) choose a unique hostname & setup DNS or /etc/hosts with the RPi name/address

## Ansible Configuration

1) install latest version of Ansible to your Ubuntu laptop

http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

2) clone the repo and CD to the `playbooks` directory

3) edit `inventory/hosts-<your_username>.ini` - add the RPi hostname

4) run ansible: `./config`

Notes:
- user-account passwords will be set to 'BamruTruck'
