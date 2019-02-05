source ~/stackrc

openstack overcloud node import ~/instackenv.json

openstack overcloud node introspect --all-manageable --provide

mkdir node-data


for node in $(openstack baremetal node list | grep -v UUID| awk '{print $4}'); do openstack baremetal introspection data save $node | jq '.inventory.interfaces' >> ~/node-data/$node-nic.json; done

for node in $(openstack baremetal node list | grep -v UUID| awk '{print $4}'); do openstack baremetal introspection data save $node | jq '.inventory.disks' >> ~/node-data/$node-disks.json; done
