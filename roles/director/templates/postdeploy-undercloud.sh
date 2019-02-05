cd /home/stack
source ~/stackrc
openstack overcloud image upload --image-path /home/stack/images/
# subnet_id=$(neutron subnet-list | grep  192.162.94.0| awk '{print $2;}')
# neutron subnet-update $subnet_id --dns-nameserver 8.8.8.8 list=true
openstack subnet set --dns-nameserver 195.80.157.4 --dns-nameserver 195.80.156.4 ctlplane-subnet
sudo openstack-config --set /etc/nova/nova.conf DEFAULT max_concurrent_builds 7

sudo openstack-config --set /etc/ironic/ironic.conf DEFAULT rpc_response_timeout 1200

sudo openstack-config --set /etc/heat/heat.conf DEFAULT rpc_response_timeout 1200

# sudo openstack-config --set /etc/heat/heat.conf cache backend dogpile.cache.memcached

# sudo openstack-config --set /etc/heat/heat.conf cache enabled True

# sudo openstack-config --set /etc/keystone/keystone.conf token expiration 25200

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 osdcompute
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="osdcompute" osdcompute

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 networker
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="networker" networker

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 fatcompute
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="fatcompute" fatcompute

# openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 odlcompute
# openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="odlcompute" odlcompute
#
################generate local_registry_images.yaml  with ceph extra services
# openstack overcloud container image prepare \
#  --output-env-file templates/docker-local.yaml \
#  --namespace registry.access.redhat.com/rhosp13 \
#  --prefix openstack- \
#  --tag=latest \
#  --push-destination=192.168.94.2:8787 \
#  --output-images-file /home/stack/local_registry_images.yaml \
#  -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
#  --set ceph_namespace=registry.access.redhat.com/rhceph \
#  --set ceph_image=rhceph-3-rhel7 \
#  --set ceph_tag=latest \
#  -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/octavia.yaml \
#  -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml \
#  -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight-sriov.yaml
#
# # #####test repo############
# #
# # curl -X GET http://192.168.94.2:8787/v2/_catalog| jq .
# sudo openstack overcloud container image upload   --config-file  /home/stack/local_registry_images.yaml   --verbose
