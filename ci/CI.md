# Continuous Integration

## Snapshots

Some provisioning steps are slow. (eg `sudo apt-get upgrade`) Create 'partial
build' disk snapshots to avoid re-executing slow commands:

    1. reset the NFS disk to the master/root (`./ci/reset_nfs_disk`)
    2. do 'partitial provisioning' (edit playbook, then `./ci/run_ansible`)
    3. create snapshot (`./sdconfig/netboot_snapshot`)
    4. restore playbook (`git checkout ./playbook/rpi-<yourPB>.yml`)

Restore the master/root to the original using `./sdconfig/netboot_snapshot
revert`
