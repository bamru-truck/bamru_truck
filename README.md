# Bamru Truck Wifi Hotspot

Development repo for the BAMRU TRUCK wifi gateway

## New Machine Setup

1) load Raspian onto a SD card

https://www.raspberrypi.org/documentation/installation/installing-images/README.md

2) boot the new machine

3) set the passwd of the 'pi' user to 'pi'

4) enable SSH 

5) choose a unique hostname

## Ansible Configuration

1) install latest version of Ansible

http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

2) CD to the `playbooks` directory

3) edit `inventory/hosts-<your_username>.ini` 

4) run ansible: `./config`

Notes:
- user-account passwords will be set to 'BamruTruck'
