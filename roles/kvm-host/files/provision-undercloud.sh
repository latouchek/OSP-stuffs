cd /var/lib/libvirt/images

qemu-img create -f qcow2 rhel7-guest.qcow2 40G
virt-resize --expand /dev/sda1 rhel7-guest-official.qcow2 rhel7-guest.qcow2
qemu-img create -f qcow2 -b rhel7-guest.qcow2 undercloud.qcow2
cloud-localds drive.img cloud-init
#virt-customize -a undercloud.qcow2 --root-password password:test
# virt-customize -a undercloud.qcow2 --run-command 'subscription-manager register --username=klatouch-tiger --password=Nitzerebb70%'
# virt-customize -a undercloud.qcow2 --run-command 'subscription-manager attach --pool=8a85f9814fd23c0b014fd6c9fe851105'
virt-customize --copy-in /root/epel:/root/ -a undercloud.qcow2
virt-customize -a undercloud.qcow2 --run-command 'rpm -ivh /root/epel'
virt-customize -a undercloud.qcow2 --run-command \
'cp /etc/sysconfig/network-scripts/ifcfg-eth{0,1} && sed -i s/DEVICE=.*/DEVICE=eth1/g /etc/sysconfig/network-scripts/ifcfg-eth1'
# ####deploy undercloud machine####
virt-install --ram 16384 --vcpus 4 --os-variant rhel7 \
--disk path=/var/lib/libvirt/images/undercloud.qcow2,device=disk,bus=virtio,format=qcow2 \
--disk path=/var/lib/libvirt/images/drive.img,device=disk,bus=virtio,format=qcow2 \
--import --noautoconsole --vnc \
--network network:default \
--network network:provisioning-net \
--name undercloud

sleep 10

mac=$(virsh domiflist undercloud | awk '/default/ {print $5};')
ipundercloud=$(grep -B1 $mac /var/lib/libvirt/dnsmasq/virbr0.status|grep ip-address| awk -F '"' '{print $4}')
echo $ipundercloud
