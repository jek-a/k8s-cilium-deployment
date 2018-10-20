#!/usr/bin/env bash

download_cfssl() {
  sudo wget -O /usr/local/bin/cfssl  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
  sudo chmod 755 /usr/local/bin/cfssl
}

download_cfssljson() {
  sudo wget -O /usr/local/bin/cfssljson  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
  sudo chmod 755 /usr/local/bin/cfssljson
}

exists() {
  if command -v $1 >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}

wget_install() {
  if test -x /usr/bin/yum; then
    sudo yum install wget -y
  fi
  if test -x /usr/bin/apt-get; then
    sudo apt-get update;
    sudo apt-get install wget -y
  fi
}

if ! exists cfssl; then
  if exists wget; then
    download_cfssl
  else
    wget_install
    download_cfssl
  fi
fi 

if ! exists cfssljson; then
  if exists wget; then
    download_cfssljson
  else
    wget_install
    download_cfssljson
  fi
fi

export CLUSTER_DOMAIN=$(kubectl get ConfigMap --namespace kube-system coredns -o yaml | awk '/kubernetes/ {print $2}')
tls/certs/gen-cert.sh $CLUSTER_DOMAIN
tls/deploy-certs.sh

kubectl label -n kube-system pod $(kubectl -n kube-system get pods -l k8s-app=kube-dns -o jsonpath='{range .items[*]}{@.metadata.name}{" "}{end}') io.cilium.fixed-identity=kube-dns

kubectl create -f ./
