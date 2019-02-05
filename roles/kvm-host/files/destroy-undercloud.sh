virsh destroy undercloud
virsh undefine undercloud
cd /var/lib/libvirt/images
rm -f rhel7-guest.qcow2 undercloud.qcow2 drive.img
