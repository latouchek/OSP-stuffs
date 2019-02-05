#For multiple disks set up make sure the first disk is being used and set at 60G
for i in `ironic node-list | awk 'NR>2' |awk '{print $2;}'`; do openstack baremetal node set --property root_device='{"name": "/dev/vda"}'  $i; done
for i in `ironic node-list | awk 'NR>2' |awk '{print $2;}'`; do openstack baremetal node set  --property local_gb=60  $i; done

#####
