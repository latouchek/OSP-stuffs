for i in $(virsh list --all | awk ' /overcloud/ { print $2 } '); do mac=$(virsh domiflist $i | awk ' /ovs/ { print $5 } '|head -n1); echo -e "$mac" >> /tmp/nodes.txt; done

scp /tmp/nodes.txt 192.168.122.2:/tmp/
