#!/usr/bin/env bash
set -m
set -x

mkfifo /tmp/vcfifo

/usr/bin/vcsim -l :443 -E /tmp/vcfifo -dc 0 -trace -api-version 6.5 &
eval "$(cat /tmp/vcfifo)"

export GOVC_INSECURE=1
TESTSTORE=/tmp/teststore
mkdir -p $TESTSTORE

/usr/bin/govc datacenter.create testdc
/usr/bin/govc cluster.create testcluster
/usr/bin/govc cluster.add -hostname testhost -username user -password pass -noverify
/usr/bin/govc datastore.create -type local -name teststore -path $TESTSTORE testcluster/*

/usr/bin/govc vm.create -disk 10M -on=false  testvm 
#/usr/bin/govc vm.markastemplate testvm 

while read line; do
    if [[ $line =~ (^[\s]*UUID:[\s]*)(.*)$ ]]; then
        uuid="${BASH_REMATCH[2]}"
        echo $uuid > /tmp/vmid
    fi
done < <(govc vm.info testvm)

#cp -f /tmp/cirros-disk.vmdk  /tmp/teststore/testvm/testvm.vmdk
#/usr/bin/govc vm.disk.attach -vm testvm -disk /tmp/teststore/testvm/testvm.vmdk -link=false
while read line; do
    if [[ $line =~ (^[\s]*File:[\s]*)(.*)$ ]]; then
        file="${BASH_REMATCH[2]}"
        echo $file > /tmp/vmdisk
    fi
done < <(govc device.info -vm testvm)

bash /run_test.sh
echo DONE
