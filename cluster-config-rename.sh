#!/bin/bash

usage()
{
  echo "Usage: cluster-config-rename.sh configfile clustername"
  exit 1
}

configfile=$1
clustername=$2
echo "configfile: $configfile"
echo "clustername: $clustername"

rename()
{
    echo "Renaming cluster in config file..."
    
    # "" is need for Mac
    # Rename context
    # Mac only: sed -ri "" "s|kubernetes-admin@kubernetes|$clustername|g" $configfile
    # Linux
    sed -ri "s/kubernetes-admin@kubernetes/$clustername/g" $configfile

    # Rename cluster
    # Mac only: sed -ri "" "s|kubernetes|$clustername|g" $configfile
    # Linux    
    sed -ri "s/kubernetes/$clustername/g" $configfile

    # Get dirname and basename
    DIR="$(dirname "${configfile}")" ; FILE="$(basename "${configfile}")"

    newfilepath="$DIR/$clustername"

    echo "configfile: $configfile"
    echo "newfilepath: $newfilepath"
    
    mv "$configfile" "$newfilepath"
}

if [ -f "$1" ]
then
    rename
else
    echo "Config file not found!"
    echo
    usage
fi

exit 1


