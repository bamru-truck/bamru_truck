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

The `build_snapshot` script performs the following actions:

    - resets the NFS drive to a clean state
    - runs all of the 'non-focus' roles in the ansible playbook
    - creates a snapshot which holds your ansible configurations

## Execute CI run

    > ./ci/all

The CI run only executes the 'focus' roles in your ansible playbook

## Disabling SSH known-host verification

Sometimes you get SSH prompts like:

    The authenticity of host 'tbd (tbd)' can't be established.
    RSA key fingerprint is f3:cf:58:ae:71:0b:c8:04:6f:34:a3:b2:e4:1e:0c:8b.
    Are you sure you want to continue connecting (yes/no)? 

These prompts can interfere with your script execution.

To disable the verification prompts, add the following lines to the beginning
of `/etc/ssh/ssh_config`:


    Host 192.168.0.*
      StrictHostKeyChecking no
      UserKnownHostsFile=/dev/null

Options:
  
  - The Host subnet can be * to allow unrestricted access to all IPs.

  - Edit `/etc/ssh/ssh_config` for global configuration or `~/.ssh/config` for
    user-specific configuration.
