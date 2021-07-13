#!/bin/bash

set -ex

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --create-namespace --namespace cert-manager \
  --version v1.4.0 \
  --set installCRDS=true

cat > secret.yaml << END
apiVersion: v1
kind: Secret
metadata:
  name: aws-route53
  namespace: cert-manager
data:
  aws_key: $(echo "${AWS_SECRET_ACCESS_KEY}" | base64)
END

cat > letsencrypt.yaml << END
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
  namespace: cert-manager
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
    email: ${EMAIL}
    solvers:
    - selector:
        dnsZones:
          - "${DNS_ZONE}"
      dns01:
        route53:
          region: ${AWS_DEFAULT_REGION}
          hostedZoneID: ${HOSTED_ZONE_ID}
          accessKeyID: ${AWS_ACCESS_KEY_ID}
          secretAccessKeySecretRef:
            name: aws-route53
            key: aws_key
END

cat > letsencrypt-staging.yaml << END
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
  namespace: cert-manager
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
    email: ${EMAIL}
    solvers:
    - selector:
        dnsZones:
          - "${DNS_ZONE}"
      dns01:
        route53:
          region: ${AWS_DEFAULT_REGION}
          hostedZoneID: ${HOSTED_ZONE_ID}
          accessKeyID: ${AWS_ACCESS_KEY_ID}
          secretAccessKeySecretRef:
            name: aws-route53
            key: aws_key
END

kubectl apply -f secret.yaml
# need to wait for the CA to be injected
sleep 20
kubectl apply -f letsencrypt.yaml
kubectl apply -f letsencrypt-staging.yaml

kubectl wait --for=condition=ready --timeout=180s clusterissuer/letsencrypt
kubectl wait --for=condition=ready --timeout=180s clusterissuer/letsencrypt-staging
