# Configuring the SD Card 

Goal: Configure raspbian to boot from a nfs drive

Netbooting allows us to quickly and automatically reset the RPi OS to a clean
state.  This is needed to run our Continuous Integration tests.

These netboot instructions are derived from the guide found here:

http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

## Prerequisites:

- Rpi 2
- SD card. (Use a fast card!!)
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
    > sudo mkdir -p /export
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

1. Download raspbian from [here](https://www.raspberrypi.org/downloads/raspbian)

2. Extract the zip file, write it to a SD card 

    > sudo dd if=./2015-05-05-raspbian-wheezy.img of=/dev/sd<WHATEVER> bs=4M
    > sudo sync

3. Unplug the SD card, then re-insert it.

4. Configure the SD card for net-booting

    > ./sdconfig/all
    
   The sdconfig/all script performs the following actions
   - change the user password to `pi`
   - change the RPi hostname
   - enable sshd
   - add ssh keys
   - modify SD to cause RPi kernel to boot from NFS
   - modify SD to automount NFS drive on RPi
   - setup MASTER and ACTIVE partitions on NFS server

   Note: If the machine you are running on is not the end NFS server, edit your
   `/media/<sd-root>/boot/cmdline.txt` file.  Alter the IP address in
   cmdline.txt, change it to the IP of your NFS server.

## DONE!

1. Unmount the SD card

    > sudo umount /dev/sd<WHATEVER>*
    > sudo sync

2. Now plug the SD card into the RPi - it will boot from the NFS drive.

