# Network booting a Raspberry Pi 2

Goal: Configure raspbian to boot from a nfs drive, in order to work in our
Continuous Integration environment.

We use net-booting to automatically setup a pristine RPi configuration in
seconds, in order to run the automated configuration and testing scripts used
in our Continuous Integration environment.

These instructions are derived from the guide found here:

http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

## Prerequisites:

- Rpi 2

- 4GB SD card. You will only be using this for booting

- Linux NFS server on your network. (could be another RPi...)

- DHCP service on your lan

## NFS Configuration

### Server Setup

    > sudo apt-get install nfs-kernel-server
    > sudo bash -c echo '/export *(rw,no_root_squash,async,no_subtree_check)' >> /etc/exports
    > sudo exportfs -ra
    > sudo /etc/init.d/nfs-kernel-server restart

### Client Testing

    > sudo apt-get install nfs-common      # nfs client packages
    > showmount -e <nfs-host>              # query NFS server for exported drives
    > mkdir nfs                            # create a mount point
    > sudo mount <nfs-host>:/drive nfs     # mount nfs drive
    > ls nfs                               # view nfs contents
    > df                                   # mounted drive should appear in partition list
    > sudo umount nfs                      # unmount nfs drive

## Preparing a bootable SD card

1. Downloaded the latest raspbian from here:

    https://www.raspberrypi.org/downloads/

2. Extract the zip file, write it to a 4GB SD card using dd

    sudo dd if=./2015-05-05-raspbian-wheezy.img of=/dev/sd<WHATEVER> bs=1M
    sudo sync

3. Boot the RPi with your SD card, and make the following changes using the
   `raspi-config` tool:

   - change the hostname
   - change the user password to `pi`
   - enable sshd

4. Run these commands on the Rpi:

    > sudo apt-get update            # update repo list
    > sudo apt-get upgrade -y -q     # upgrade packages
    > sudo rpi-update                # update the kernel to latest

5. Add ssh keys 

    - instructions TBD
    - after this step, you should be able to SSH to the RPi without a password

      > ssh pi@<hostname>

You now have a clean bootable image.

## Saving your bootable image

    > sudo umount /dev/sd<WHATEVER>*
    > sudo dd bs=4M if=/dev/sd<WHATEVER> of=bootable.img

## Creating and saving a net-bootable configuration

1. Unplug the sd card, then plug it into your server.

2. Run a configuration script to force the RPi kernel to netboot

    > ./
    
3. Run a configuration script to setup the RPi /etc/fstab for nfs automount

    > ./



## Saving your net-bootable configuration

4. On the server, create /export/raspbian/2015-05-05-raspbian-wheezy-base copy
   the contents of the root from the sd card to
   /export/raspbian/2015-05-05-raspbian-wheezy-base

5. Copy the contents of the boot to
   /export/raspbian/2015-05-05-raspbian-wheezy-base/boot


Edit the fstab in your RPi image:

    sudo vim /export/raspbian/2015-05-05-raspbian-wheezy-base/etc/fstab

It should look like this:

    proc            /proc           proc    defaults          0       0
    #/dev/mmcblk0p1  /boot           vfat    defaults          0       2
    #/dev/mmcblk0p2  /               ext4    defaults,noatime  0       1
    /dev/nfs    /    rootfs  defaults,rw  
    tmpfs  /tmp     tmpfs  nodev,nosuid,size=10%,mode=1777  0  0
    tmpfs  /var/log tmpfs  nodev,nosuid,size=20%,mode=1755  0  0

Touch the tmpfs on the image to keep init from complaining:

    sudo touch /export/raspbian/2015-05-05-raspbian-wheezy-base/tmp/.tmpfs

Edit the interfaces file to keep the ip address on the RPi after boot

Edit /export/raspbian/2015-05-05-raspbian-wheezy-base/etc/network/interfaces

The only line you need to worry about is the one with eth0

Mine looks like this:

    auto lo
    iface lo inet loopback
    auto eth0
    allow-hotplug eth0
    iface eth0 inet static
    auto wlan0
    allow-hotplug wlan0
    iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
    auto wlan1
    allow-hotplug wlan1
    iface wlan1 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

Copy the image to a new path:

Preserve the nfs base for use with new RPis later. Copy it to a new working
location.

    cd /export/raspbian
    sudo cp -a 2015-05-05-raspbian-wheezy-base working

Modify the boot sd card:

I do not have a good way to modify my dhcp server on this network to add a nfs
root path line.

So, this RPi will still boot the kernel off of the sd card, while mounting the
root off of the network.

Put the SD card into your system and edit the cmdline.txt file on the boot
partition.

Edit it to be similar to this one:

    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 ip=dhcp root=/dev/nfs nfs-options=hard,intr,rw,size=32768,wsize=32768 rootfstype=nfs elevator=deadline rootwait nfsroot=<nfs server>:/export/raspbian/working rootpath=/export/raspbian/working

Make sure you change the <nfs server> bit.

Put your sd card back into your RPi and boot it. It should network boot.

## CI Compatibility

Needs:
- a hostname
- ssh
- an updated linux kernel

