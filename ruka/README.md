ruka cluster deployment
========================

```bash
ssh ruka01.ls.lsst.org
sudo -iu rke
git clone https://github.com/lsst-it/k8s-cookbook
cd k8s-cookbook/ruka/

(cd rke; rke up)
export KUBECONFIG=/home/rke/k8s-cookbook/ruka/rke/kube_config_cluster.yml

(cd metallb; ./metallb.sh)

(cd ingress; ./nginx-ingress-helm.sh)

(cd rook-ceph; ./rook-ceph.sh)

```

import andes cluster into rancher via this url:

https://rancher.cp.lsst.org/g/clusters/add/launch/import
