cd /home/stack
source ~/stackrc
openstack overcloud image upload --image-path /home/stack/images/
subnet_id=$(neutron subnet-list | grep  192.162.94.0| awk '{print $2;}')
# neutron subnet-update $subnet_id --dns-nameserver 8.8.8.8 list=true
#
# sudo openstack-config --set /etc/ironic/ironic.conf DEFAULT rpc_response_timeout 600
#
# sudo openstack-config --set /etc/heat/heat.conf DEFAULT rpc_response_timeout 1200
#
# sudo openstack-config --set /etc/heat/heat.conf cache backend dogpile.cache.memcached
#
# sudo openstack-config --set /etc/heat/heat.conf cache enabled True
#
# sudo openstack-config --set /etc/keystone/keystone.conf token expiration 25200
