#!/bin/bash

set -x

SSH_USER=hreinking_b

HOST="pillan01.ls.lsst.org"
SSH_CMD="ssh ${HOST} -l ${SSH_USER}"
DEV=/dev/nvme1n1

${SSH_CMD} sudo rm -rf /var/lib/rook
${SSH_CMD} sudo sh -c 'ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %'
${SSH_CMD} sudo rm -rf /dev/ceph-*
${SSH_CMD} sudo sgdisk --zap-all "$DEV"
${SSH_CMD} sudo dd if=/dev/zero "of=${DEV}" bs=1M count=100 oflag=direct,dsync
${SSH_CMD} sudo blockdev --rereadpt "$DEV"
${SSH_CMD} sudo reboot
