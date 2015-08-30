# Network booting a Raspberry Pi 2

Goal: Get raspbian to a point where it is booting off of a nfs share on a
network without a very versatile dhcp server(ie, the dhcp server you might have
in a home router).

## Prerequisites:

- Rpi 2

- SD card 4 GB or greater. You will only be using this for booting

- Linux server on your network. (could be another RPi...)

These instructions are based off of the guide found here:

http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

I needed to make some alterations.

Start with the SD card:

1. Downloaded the latest raspbian from here:
    https://www.raspberrypi.org/downloads/

2. Extract the zip file, write it to the sd card using dd
        dd if=./2015-05-05-raspbian-wheezy.img of=/dev/sd(WHATEVER) bs=1M

3. sync, then unplug the sd card, then plug it into your server

   If your server does not automatically mount the sd card, mount the root and
   boot partitions.

4. On the server, create /export/raspbian/2015-05-05-raspbian-wheezy-base copy
   the contents of the root from the sd card to
   /export/raspbian/2015-05-05-raspbian-wheezy-base

5. Copy the contents of the boot to /export/raspbian/2015-05-05-raspbian-wheezy-base/boot

On the server, you will need to set up a nfs server:

    sudo aptitude install nfs-kernel-server
    sudo bash -c echo '/export *(rw,no_root_squash,async,no_subtree_check)' >> /etc/exports
    sudo exportfs -ra
    sudo /etc/init.d/nfs-kernel-server restart

edit the fstab of your image:

    sudo vim /export/raspbian/2015-05-05-raspbian-wheezy-base/etc/fstab

You will want to edit it to look like this:

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

You probably want to preserve the nfs base for use with new RPi’s later. Copy
it to a new working location.

    sudo cp -a /export/raspbian/2015-05-05-raspbian-wheezy-base /export/raspbian/working

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

That should be it. Put your sd card back into your RPi and boot it. It should network boot.

Enjoy-
