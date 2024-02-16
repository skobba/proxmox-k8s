# CNI Plugin

Check CNI Plugin Installation: Ensure that the CNI plugin required for your network setup is installed on the Alpine Linux nodes. For example, if you're using Flannel, ensure that the Flannel CNI binaries are installed. You can typically find these binaries in the /opt/cni/bin/ directory.

Verify CNI Configuration: Check the CNI configuration files located in the /etc/cni/net.d/ directory. Make sure that the configuration file for your CNI plugin (e.g., flannel.conf) is correctly set up and points to the correct binary path.

# kubeadm init
W0213 16:46:41.909360    2683 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.

kubeadm join 10.10.9.60:6443 --token cyc648.04b0t2s0bdje8pvr \
	--discovery-token-ca-cert-hash sha256:04541060e77346d6eda9286b5abc930bafaa151306156afb08d05b073e11fa0f

## Events
Events:
  Type     Reason                  Age                   From               Message
  ----     ------                  ----                  ----               -------
  Warning  FailedScheduling        3m35s                 default-scheduler  0/1 nodes are available: 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.
  Normal   Scheduled               3m26s                 default-scheduler  Successfully assigned kube-system/coredns-76f75df574-ltplc to master
  Warning  FailedCreatePodSandBox  3m26s                 kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "3f5f0f26cfe79ee26cb9146372e45970cc6929c00e5f093166b53b9f857ce27e": plugin type="flannel" failed (add): failed to find plugin "flannel" in path [/usr/libexec/cni]
  Normal   SandboxChanged          15s (x16 over 3m25s)  kubelet            Pod sandbox changed, it will be killed and re-created.
  

# apk
echo "br_netfilter" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter
apk add cni-plugin-flannel
apk add cni-plugins
apk add flannel
apk add flannel-contrib-cni

# Taint master
kubectl taint nodes  mildevkub020 node-role.kubernetes.io/master-
kubectl taint nodes  mildevkub040 node-role.kubernetes.io/master-

kubectl taint nodes --all node.kubernetes.io/not-ready-

kubectl describe pod coredns-76f75df574-glg6v -n kube-system

  Warning  FailedMount       7m42s (x7 over 8m14s)    kubelet            MountVolume.SetUp failed for volume "config-volume" : object "kube-system"/"coredns" not registered
  Warning  NetworkNotReady   3m12s (x152 over 8m14s)  kubelet            network is not ready: container runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:Network plugin returns error: cni plugin not initialized

