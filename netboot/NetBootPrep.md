# Network booting a Raspberry Pi 2

Goal: Configure raspbian to boot from a nfs drive

Netbooting allows us to quickly and automatically reset the RPi OS to a clean
state.  This is needed to run our Continuous Integration tests.

These netboot instructions are derived from the guide found here:

http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

## Prerequisites:

- Rpi 2
- 4GB SD card. (SanDisk Ultra for fast Disk I/O)
- Linux NFS server on your network. (Ubuntu Laptop)
- DHCP service on your lan

## Approach

The RPi SD card has two partitions:
+--------------+-------------------+------------+------------+------+
| Partition    | Contains          | Access     | Hosted On  | Size |
+--------------+-------------------+------------+------------+------+
| boot @ /boot | boot instructions | read only  | SD Card    | Megs |
| root @ /     | the whole OS      | read/write | NFS Server | Gigs |
+--------------+-------------------+------------+------------+------+

Two copies of the root partition are maintained on the NFS Server:
- a MASTER copy, which has the original base version of the OS
- an ACTIVE copy, which is NFS-mounted to the RPi

During a CI run, here is how we reset the RPi OS to a clean state:
- delete the ACTIVE directory on the NFS server
- copy the MASTER directory to the ACTIVE directory
- powercycle the RPi

## Directories

### SD Card

When you plug the SD card into your NFS server, the boot and root partitions
are auto-mounted:

    /media/boot                              # the boot partition
    /media/<long UUID-like name>             # the root partition

You can browse/edit/update any contents of the auto-mounted SD card.

### NFS Drives

All of the NFS data is stored under path /export/raspbian

    /export/raspbian/master/boot       # the master boot partition
    /export/raspbian/master/root       # the master root partition
    /export/raspbian/active/root       # the active root partition

Only the active/root directory is mounted onto the RPi.

## NFS Configuration

### Server Setup

    > sudo apt-get install nfs-kernel-server
    > sudo mkdir -f /export
    > sudo echo '/export *(rw,no_root_squash,async,no_subtree_check)' >> /etc/exports
    > sudo exportfs -ra
    > sudo /etc/init.d/nfs-kernel-server restart

### Client Testing

    > sudo apt-get install nfs-common    # nfs client packages
    > showmount -e <nfs-host>            # query NFS server for exported drives
    > mkdir nfs                          # create a mount point
    > sudo mount <nfs-host>:/export nfs  # mount nfs drive
    > ls nfs                             # view nfs contents
    > df                                 # mounted drive should appear in list
    > sudo umount nfs                    # unmount nfs drive

## Preparing a bootable SD card

1. Download raspbian from [here](https://www.raspberrypi.org/downloads)

2. Extract the zip file, write it to a 4GB SD card 

    > sudo dd if=./2015-05-05-raspbian-wheezy.img of=/dev/sd<WHATEVER> bs=4M
    > sudo sync

3. Boot the RPi with your SD card, and make the following changes using the
   `raspi-config` tool:

   - change the user password to `pi`
   - change the RPi hostname
   - enable sshd

4. Run these commands on the RPi

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

2. Run configuration scripts to setup netbooting

    > ./netboot/prep_cmdline # modify SD to cause RPi kernel to boot from NFS
    > ./netboot/prep_fstab   # modify SD to automount NFS drive on RPi
    > ./netboot/prep_nfs     # setup MASTER and ACTIVE partitions on NFS server

## DONE!

1. Unmount the SD card

    > sudo umount /dev/sd<WHATEVER>*
    > sudo sync

2. Now plug the SD card into the RPi.  Powerup the RPi and it will boot from
   the NFS drive.

