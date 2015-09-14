# Continuous Integration

## Preparing your RPi for CI

1. prep a SD Card

2. boot in your RPi

3. on the RPi:

    > exit out of the 'raspi-config' program
    > run 'sudo rpi-update' to update the kernel
    > reboot the machine
    > verify that you can ssh to the machine 'ssh pi@<machine>'

4. build a snapshot

    > ./ci/build_snapshot

   NOTE: first run you may have to type 'yes' to verify known-hosts settings

## Execute CI run

    > ./ci/all

