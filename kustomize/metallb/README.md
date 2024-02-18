# metallb
Ref:
* https://www.youtube.com/watch?v=k8bxtsWe9qw


## 1. Enable strictARP=true

```
kubectl edit configmap -n kube-system kube-proxy
```

## 2. Install manifest
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml

Result:
role.rbac.authorization.k8s.io/controller created
role.rbac.authorization.k8s.io/pod-lister created
clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
rolebinding.rbac.authorization.k8s.io/controller created
rolebinding.rbac.authorization.k8s.io/pod-lister created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
configmap/metallb-excludel2 created
secret/webhook-server-cert created
service/webhook-service created
deployment.apps/controller created
daemonset.apps/speaker created
validatingwebhookconfiguration.admissionregistration.k8s.io/metallb-webhook-configuration created
```

## Check
```
kubectl api-resources|grep metallb
kubectl get ipaddresspools.metallb.io -n metallb-system
```


## With helm
```sh
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb -f values.yaml
```