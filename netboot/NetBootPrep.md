# Network booting a Raspberry Pi 2

Goal: Configure raspbian to boot from a nfs drive

We use net-booting to automatically reset the RPi to a clean state.  This is
needed to run the automated configuration and testing scripts used in our
Continuous Integration environment.

These netboot instructions are derived from the guide found here:

http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

## Prerequisites:

- Rpi 2

- 4GB SD card. You will only be using this for booting

- Linux NFS server on your network. (could be another RPi...)

- DHCP service on your lan

## NFS Configuration

### Server Setup

    > sudo apt-get install nfs-kernel-server
    > sudo mkdir -f /export
    > sudo echo '/export *(rw,no_root_squash,async,no_subtree_check)' >> /etc/exports
    > sudo exportfs -ra
    > sudo /etc/init.d/nfs-kernel-server restart

### Client Testing

    > sudo apt-get install nfs-common   # nfs client packages
    > showmount -e <nfs-host>           # query NFS server for exported drives
    > mkdir nfs                         # create a mount point
    > sudo mount <nfs-host>:/drive nfs  # mount nfs drive
    > ls nfs                            # view nfs contents
    > df                                # mounted drive should appear in list
    > sudo umount nfs                   # unmount nfs drive

## Preparing a bootable SD card

1. Download the [latest raspbian](https://www.raspberrypi.org/downloads)

2. Extract the zip file, write it to a 4GB SD card 

    sudo dd if=./2015-05-05-raspbian-wheezy.img of=/dev/sd<WHATEVER> bs=4M
    sudo sync

3. Boot the RPi with your SD card, and make the following changes using the
   `raspi-config` tool:

   - change the user password to `pi`
   - change the RPi hostname
   - enable sshd

4. Run these commands on the Rpi:

    > sudo apt-get update            # update repo list
    > sudo apt-get upgrade -y -q     # upgrade packages
    > sudo rpi-update                # update to newest kernel

5. Add ssh keys 

    - instructions TBD
    - after this step, you should be able to SSH to the RPi without a password

      > ssh pi@<hostname>

You now have a clean bootable image.

## Saving your bootable image

Insert your SD card into your NFS server, then:

    > sudo umount /dev/sd<WHATEVER>*
    > sudo dd bs=4M if=/dev/sd<WHATEVER> of=bootable.img

## Creating and saving a net-bootable configuration

1. Unplug the sd card, then re-insert into your server.

2. Run a configuration script to force the RPi kernel to netboot

    > ./netboot/prep_rpi_cmdline
    
3. Run a configuration script to setup the RPi /etc/fstab for nfs automount

    > ./netboot/prep_rpi_fstab

4. On the server, create /export/raspbian/2015-05-05-raspbian-wheezy-base copy
   the contents of the root from the sd card to
   /export/raspbian/2015-05-05-raspbian-wheezy-base

5. Copy the contents of the boot to
   /export/raspbian/2015-05-05-raspbian-wheezy-base/boot

## Wrapup

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

Put your sd card back into your RPi and boot it. It should network boot.

