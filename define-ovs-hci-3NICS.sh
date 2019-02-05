#!/usr/bin/env bash


for i in $(virsh list --all | awk ' /overcloud/ { print $2 } '); do \
	 virsh destroy $i; virsh undefine $i; rm -f /var/lib/libvirt/images/$i.qcow2; \
done
rm -f /tmp/nodes.txt
cd /var/lib/libvirt/images/
rm -f overcloud-c*

for i in ctrl01 ctrl02 ctrl03 compute01 compute02 compute03 osdcompute01 osdcompute02 osdcompute03 ceph01 ceph02 ceph03 networker;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i.qcow2 45G;
done

for i in ceph01 ceph02 ceph03 osdcompute01 osdcompute02 osdcompute03 ;
do
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i-storage-osd1.qcow2 60G;
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i-storage-osd2.qcow2 60G;
	qemu-img create -f qcow2 -o preallocation=metadata overcloud-$i-storage-jnl.qcow2 60G;

done

for i in ctrl01 ctrl02 ctrl03 ;
do
	virt-install --ram 16000 --vcpus 8 --os-variant rhel7 \
	--disk path=/var/lib/libvirt/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc \
	--network network=ovs-trunk-network,portgroup=vlan-native \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml

	virsh define --file /tmp/overcloud-$i.xml;
done

for i in compute01 compute02 compute03;
do
	virt-install --ram 8192 --vcpus 8 --os-variant rhel7 \
	--disk path=/var/lib/libvirt/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc \
	--network network=ovs-trunk-network,portgroup=vlan-native \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done

for i in ceph01 ceph02 ceph03 ;
do
	virt-install --ram 4096 --vcpus 2 --os-variant rhel7 \
	--disk path=/var/lib/libvirt/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-osd1.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-osd2.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-jnl.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc \
	--network network=ovs-trunk-network,portgroup=vlan-native \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done
for i in  osdcompute01 osdcompute02 osdcompute03;
do
	virt-install --ram 8192 --vcpus 16 --os-variant rhel7 \
	--disk path=/var/lib/libvirt/images/overcloud-$i.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-osd1.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-osd2.qcow2,device=disk,bus=virtio,format=qcow2 \
	--disk path=/var/lib/libvirt/images/overcloud-$i-storage-jnl.qcow2,device=disk,bus=virtio,format=qcow2 \
	--noautoconsole --vnc \
	--network network=ovs-trunk-network,portgroup=vlan-native \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--network network=ovs-trunk-network,portgroup=vlan-all \
	--name overcloud-$i \
	--cpu SandyBridge,+vmx \
	--dry-run --print-xml > /tmp/overcloud-$i.xml; \
	virsh define --file /tmp/overcloud-$i.xml;
done

virt-install --ram 4096 --vcpus 2 --os-variant rhel7 \
        --disk path=/var/lib/libvirt/images/overcloud-networker.qcow2,device=disk,bus=virtio,format=qcow2 \
        --noautoconsole --vnc --network network=ovs-trunk-network,portgroup=vlan-native \
        --network network=ovs-trunk-network,portgroup=vlan-all \
        --name overcloud-networker \
        --cpu SandyBridge,+vmx \
        --dry-run --print-xml > /tmp/overcloud-networker.xml; \
        virsh define --file /tmp/overcloud-networker.xml;



##

# for i in $(virsh list --all | awk ' /overcloud/ { print $2 } '); \
#     do mac=$(virsh domiflist $i | awk ' /net-provisioning/ { print $5 } '); \
#     echo -e "$mac" >> /tmp/nodes.txt; done


for i in $(virsh list --all | awk ' /overcloud/ { print $2 } '); do mac=$(virsh domiflist $i | awk ' /ovs/ { print $5 } '|head -n1); echo -e "$mac" >> /tmp/nodes.txt; done

scp /tmp/nodes.txt 192.168.122.2:/tmp/
