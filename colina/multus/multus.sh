#!/bin/bash

set -ex

( set -ex
  git clone https://github.com/intel/multus-cni -b v3.4
  cd multus-cni
  kubectl apply -f images/multus-daemonset.yml
)

kubectl apply -f multus-nad-default.yaml

# vim: tabstop=2 shiftwidth=2 expandtab
