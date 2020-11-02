#!/bin/bash

set -x

SSH_USER=hreinking_b

HOST="ruka02.ls.lsst.org"
SSH_CMD="ssh ${HOST} -l ${SSH_USER}"
${SSH_CMD} sudo rm -rf /var/lib/rook
${SSH_CMD} sudo sh -c 'ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %'
${SSH_CMD} sudo rm -rf /dev/ceph-*
${SSH_CMD} sudo sgdisk --zap-all /dev/sdc
${SSH_CMD} sudo dd if=/dev/zero of=/dev/sdc bs=1M count=100 oflag=direct,dsync
${SSH_CMD} sudo blockdev --rereadpt /dev/sdc

HOST="ruka03.ls.lsst.org"
${SSH_CMD} sudo rm -rf /var/lib/rook
${SSH_CMD} sudo sh -c 'ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %'
${SSH_CMD} sudo rm -rf /dev/ceph-*
${SSH_CMD} sudo sgdisk --zap-all /dev/sdc
${SSH_CMD} sudo dd if=/dev/zero of=/dev/sdc bs=1M count=100 oflag=direct,dsync
${SSH_CMD} sudo blockdev --rereadpt /dev/sdc

HOST="ruka04.ls.lsst.org"
${SSH_CMD} sudo rm -rf /var/lib/rook
${SSH_CMD} sudo sh -c 'ls /dev/mapper/ceph-* | xargs -I% -- dmsetup remove %'
${SSH_CMD} sudo rm -rf /dev/ceph-*
${SSH_CMD} sudo sgdisk --zap-all /dev/sdd
${SSH_CMD} sudo dd if=/dev/zero of=/dev/sdd bs=1M count=100 oflag=direct,dsync
${SSH_CMD} sudo blockdev --rereadpt /dev/sdd
