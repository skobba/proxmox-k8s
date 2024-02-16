#!/bin/bash

clusters=$(cat clusters.json |  jq -r '.[] | @base64')

for cluster in $clusters; do
    _jq() {
     echo ${cluster} | base64 --decode | jq -r ${1}
    }

    clusterid=$(_jq '.id')
    nodes=$(_jq '.nodes')
    br=$(_jq '.br')
    ip=$(_jq '.ip')

    for ((i=1; i<=$nodes; i++)); do

        type=$([ "$i" -eq "1" ] && echo "master" || echo "worker")
        template=7000
        nodename=kc$clusterid"n"$i
        nodeid=1$clusterid$i
        fullip=$ip.1$clusterid$i
        
        ./vm-from-template.sh $template $nodename $nodeid $br $fullip

        clusterjoinfile=""

        case "$type" in
        master)
            echo "Setup master"
            ssh-keygen -f "/root/.ssh/known_hosts" -R "$fullip"
            ssh -o StrictHostKeyChecking=accept-new root@$fullip 'sh -s' < vm-setup-master.sh

            echo "Copying joincluster.sh"
            clusterjoinfile="./cluster-join-files/joincluster$nodeid.sh"
            scp root@$fullip:/joincluster.sh .
            mv ./joincluster.sh $clusterjoinfile

            # Get cluster config and rename is
            contextname="kube$nodeid"
            echo "Rename cluster config to: $contextname"
            newconfig="./custom-contexts/newconfig$nodeid"
            scp root@$fullip:/root/.kube/config "$newconfig"
            ./cluster-config-rename.sh "$newconfig" "$contextname"

            ;;

        worker)
            echo "Setup worker"
            ssh-keygen -f "/root/.ssh/known_hosts" -R "$fullip"
            ssh -o StrictHostKeyChecking=accept-new root@$fullip 'sh -s' < vm-setup-worker.sh
            
            echo "Copy $clusterjoinfile"
            masterid=1"$clusterid"1
            clusterjoinfile="./cluster-join-files/joincluster$masterid.sh"
            chmod +x $clusterjoinfile
            scp $clusterjoinfile root@$fullip:/joincluster.sh 
            ssh -o StrictHostKeyChecking=accept-new root@$fullip /joincluster.sh 
            ;;
        esac

    done

done


