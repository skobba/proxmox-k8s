# ingress-nginx
Ref.: 
* [Install baremetal](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters)
* [Baremetal considerations](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/)
* Baremetal: https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/baremetal/deploy.yaml
* https://github.com/morrismusumi/kubernetes/tree/main/clusters/homelab-k8s/apps/metallb-plus-nginx-ingress
* https://www.youtube.com/watch?v=k8bxtsWe9qw


curl -D- http://10.10.9.125 -H 'Host: nginx.example.com'