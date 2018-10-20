This repository installs Cilium v1.2.3 on K8S and solves a problem with the following bug: https://github.com/cilium/cilium/issues/5941

# Usage
1. Clone repository
2. Run
```
kubeadm init <args>
```
3. cd k8s-cilium-deployment
4. Run 'install.sh'. This script installs the following tools: **cfssl**, **cfssljson** in order to generate TLS certs for Etcd cluster. Also, if your system does not have **wget** it installs it as well.
```
$ ./install.sh
generating CA certs ===
2018/10/20 08:20:11 [INFO] generating a new CA key and certificate from CSR
2018/10/20 08:20:11 [INFO] generate received request
2018/10/20 08:20:11 [INFO] received CSR
2018/10/20 08:20:11 [INFO] generating key: rsa-2048
2018/10/20 08:20:12 [INFO] encoded CSR
2018/10/20 08:20:12 [INFO] signed certificate with serial number 333035311007085322159038949723296412328068498820
generating etcd peer.json for cluster domain cluster.local ===
generating etcd peer certs ===
2018/10/20 08:20:12 [INFO] generate received request
2018/10/20 08:20:12 [INFO] received CSR
2018/10/20 08:20:12 [INFO] generating key: rsa-2048
2018/10/20 08:20:12 [INFO] encoded CSR
2018/10/20 08:20:12 [INFO] signed certificate with serial number 194312650000410101299320852606442695398550816766
2018/10/20 08:20:12 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
generating etcd server certs ===
2018/10/20 08:20:12 [INFO] generate received request
2018/10/20 08:20:12 [INFO] received CSR
2018/10/20 08:20:12 [INFO] generating key: rsa-2048
2018/10/20 08:20:12 [INFO] encoded CSR
2018/10/20 08:20:12 [INFO] signed certificate with serial number 597223081856199572787409946737948252146591724443
2018/10/20 08:20:12 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
generating etcd client certs ===
2018/10/20 08:20:12 [INFO] generate received request
2018/10/20 08:20:12 [INFO] received CSR
2018/10/20 08:20:12 [INFO] generating key: rsa-2048
2018/10/20 08:20:12 [INFO] encoded CSR
2018/10/20 08:20:12 [INFO] signed certificate with serial number 413947960771053900186284765072947982740258479101
2018/10/20 08:20:12 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
secret/cilium-etcd-peer-tls created
secret/cilium-etcd-server-tls created
secret/cilium-etcd-client-tls created
pod/coredns-576cbf47c7-65l44 labeled
pod/coredns-576cbf47c7-hxqzp labeled
customresourcedefinition.apiextensions.k8s.io/etcdclusters.etcd.database.coreos.com created
configmap/cilium-config created
daemonset.extensions/cilium created
clusterrolebinding.rbac.authorization.k8s.io/cilium created
clusterrole.rbac.authorization.k8s.io/cilium created
serviceaccount/cilium created
etcdcluster.etcd.database.coreos.com/cilium-etcd created
serviceaccount/cilium-etcd-sa created
clusterrolebinding.rbac.authorization.k8s.io/etcd-operator created
clusterrole.rbac.authorization.k8s.io/etcd-operator created
deployment.extensions/etcd-operator created
configmap/etcd-liveness-check created
deployment.apps/etcd-cluster-liveness created
```
5. Join your worker nodes
```
kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>
```

In about 5 min you will get working K8S cluster with Cilium v1.2.3

Example with 25 worker nodes:
```
$ kubectl get po -n kube-system
NAME                                                READY   STATUS    RESTARTS   AGE
cilium-2f9qq                                        1/1     Running   0          2m9s
cilium-2sx6p                                        1/1     Running   0          2m9s
cilium-4ms5l                                        1/1     Running   0          2m12s
cilium-5c754                                        1/1     Running   0          2m12s
cilium-74bd5                                        1/1     Running   0          2m13s
cilium-76n2d                                        1/1     Running   0          6m14s
cilium-9ztc8                                        1/1     Running   0          2m11s
cilium-bwht9                                        1/1     Running   0          2m11s
cilium-cc8hj                                        1/1     Running   0          2m13s
cilium-d6r9v                                        1/1     Running   0          2m9s
cilium-etcd-6jlnt96jxj                              1/1     Running   0          5m55s
cilium-etcd-9tqvjf5bjl                              1/1     Running   0          4m48s
cilium-etcd-qwmxq5pzqs                              1/1     Running   0          5m28s
cilium-hk9g9                                        1/1     Running   0          2m11s
cilium-j7v9d                                        1/1     Running   0          2m11s
cilium-j8t6m                                        1/1     Running   0          6m14s
cilium-jcz9t                                        1/1     Running   0          2m11s
cilium-jfklw                                        1/1     Running   0          2m10s
cilium-jksr4                                        1/1     Running   0          2m13s
cilium-k5n6n                                        1/1     Running   0          2m11s
cilium-nwbdq                                        1/1     Running   0          2m10s
cilium-q76vc                                        1/1     Running   0          2m12s
cilium-rnxkv                                        1/1     Running   0          2m13s
cilium-s4dk7                                        1/1     Running   0          2m9s
cilium-s5ttz                                        1/1     Running   0          2m10s
cilium-srhzd                                        1/1     Running   0          2m12s
cilium-tg6m2                                        1/1     Running   0          2m10s
cilium-tlwlg                                        1/1     Running   0          2m16s
cilium-tsrsd                                        1/1     Running   0          2m10s
cilium-v9vl5                                        1/1     Running   0          2m13s
cilium-vpprq                                        1/1     Running   0          2m9s
cilium-vrd2r                                        1/1     Running   0          2m11s
cilium-w62jn                                        1/1     Running   0          2m13s
cilium-w76wt                                        1/1     Running   0          2m11s
cilium-wqtdh                                        1/1     Running   0          2m10s
cilium-x69wg                                        1/1     Running   0          2m11s
cilium-xpgnb                                        1/1     Running   0          2m11s
coredns-576cbf47c7-72sqf                            1/1     Running   0          17m
coredns-576cbf47c7-fsntx                            1/1     Running   0          17m
etcd-cluster-liveness-6f496cfdcf-kg8vv              1/1     Running   0          6m15s
etcd-operator-7cb79cdf99-fxwns                      1/1     Running   0          6m15s
etcd-master-1                                       1/1     Running   0          16m
kube-apiserver-master-1                             1/1     Running   0          16m
kube-controller-manager-master-1                    1/1     Running   0          16m
kube-proxy-4rhtm                                    1/1     Running   0          2m11s
kube-proxy-4xpks                                    1/1     Running   0          2m11s
kube-proxy-58q4w                                    1/1     Running   0          2m13s
kube-proxy-6lfsl                                    1/1     Running   0          2m10s
kube-proxy-7dv88                                    1/1     Running   0          2m13s
kube-proxy-7zc6q                                    1/1     Running   0          2m12s
kube-proxy-8v6kg                                    1/1     Running   0          17m
kube-proxy-d2r9r                                    1/1     Running   0          2m10s
kube-proxy-dxz7n                                    1/1     Running   0          2m13s
kube-proxy-fj92j                                    1/1     Running   0          2m10s
kube-proxy-fvw76                                    1/1     Running   0          2m9s
kube-proxy-hklcb                                    1/1     Running   0          2m13s
kube-proxy-hrtqv                                    1/1     Running   0          2m11s
kube-proxy-jf67p                                    1/1     Running   0          2m12s
kube-proxy-m6hxs                                    1/1     Running   0          2m10s
kube-proxy-m76sl                                    1/1     Running   0          2m10s
kube-proxy-mfmp7                                    1/1     Running   0          2m12s
kube-proxy-mh44z                                    1/1     Running   0          16m
kube-proxy-mn7h7                                    1/1     Running   0          2m9s
kube-proxy-nt87p                                    1/1     Running   0          2m12s
kube-proxy-pf82b                                    1/1     Running   0          2m11s
kube-proxy-pl8wl                                    1/1     Running   0          2m13s
kube-proxy-qfsz8                                    1/1     Running   0          2m12s
kube-proxy-qrwtr                                    1/1     Running   0          2m16s
kube-proxy-r7d2n                                    1/1     Running   0          2m10s
kube-proxy-rlw8t                                    1/1     Running   0          2m11s
kube-proxy-t89db                                    1/1     Running   0          2m13s
kube-proxy-t97gt                                    1/1     Running   0          2m10s
kube-proxy-tdw5r                                    1/1     Running   0          2m11s
kube-proxy-wtvf5                                    1/1     Running   0          2m12s
kube-proxy-x846q                                    1/1     Running   0          2m9s
kube-proxy-xn9gm                                    1/1     Running   0          2m12s
kube-proxy-zkclw                                    1/1     Running   0          2m10s
kube-proxy-zx8gp                                    1/1     Running   0          2m11s
kube-scheduler-master-1                             1/1     Running   0          16m
```
