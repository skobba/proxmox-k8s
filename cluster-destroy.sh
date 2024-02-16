#!/bin/bash

printClusters()
{
    vmnames=$(qm list | awk 'NR>1 && $2 ~ /^kc/ {print $2}')

    # Extract the first three letters from each name
    short_names=$(echo "$vmnames" | cut -c 1-3)
    # Remove duplicates and sort the list
    unique_short_names=$(echo "$short_names" | sort -u)
    # Remove kc
    clusterid=$(echo "$unique_short_names" | sed '/kc/d')

    echo "Clusters:"
    echo "$unique_short_names"
    echo
    echo "Usage: ./cluster-destroy.sh [--destroy|-d] KLUSTERNAME"
    echo
    echo "Eg.1: ./cluster-destroy.sh -d kc1"
    echo
    exit 1
    
}


destroyCluster()
{
    echo -e "\nDestroying Kubernetes Cluster: $1\n"
    # Remove kc from clustername
    clusterid=$(echo "$1" | echo "$1" | sed 's/.*\([0-9]\)$/\1/')
    echo "clusterid: $clusterid"

    vmnames=$(qm list | awk 'NR>1 && $2 ~ /^kc/ {print $2}')

    # Get only nodes in this cluster
    prefix="$1"
    nodes=$(echo "$vmnames" | awk -v prefix="$prefix" '$0 ~ "^" prefix')
    
    echo "Deleting nodes:"
    echo $nodes
    echo

    for node in $nodes
    do
        # echo "kc1n1" | grep -oE '[0-9]+$'
        nodeindex=$(echo "$node" | grep -oE '[0-9]+$')
        nodeid=1$clusterid""$nodeindex

        echo "==> Destroying $nodeid..."
        qm shutdown $nodeid
        qm stop $nodeid
        qm destroy $nodeid
        
        # zfs destroy -r "rpool/docker/$node"
        # zfs destroy -r "rpool/kubernetes/$node"
    done
}



case "$1" in
   -d|--destroy)
    if [[ -z $2 ]] ; then
      echo "cluster: $2"
    else
      cluster=$2
      destroyCluster $2
    fi
    ;;

   -d|--destroy)
    destroyCluster
    ;;
  "")
    printClusters
    ;;
  *)
    printClusters
    ;;
esac
