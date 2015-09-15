# Continuous Integration

## Preparing your RPi for CI

1. prep a SD Card

2. boot in your RPi

3. on the RPi:

    - exit out of the 'raspi-config' program
    - reboot the machine
    - verify that you can ssh to the machine 'ssh pi@<machine>'

4. build a snapshot

    > ./ci/build_snapshot

The build_snapshot script performs the following actions:

    - resets the NFS drive to a clean state
    - runs all of the 'non-focus' roles in the ansible playbook
    - creates a snapshot which holds your ansible configurations

NOTE: first run you may have to type 'yes' to verify known-hosts settings.

## Execute CI run

    > ./ci/all

The CI run only executes the 'focus' roles in your ansible playbook
