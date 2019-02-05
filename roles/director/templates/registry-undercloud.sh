cd /home/stack
source ~/stackrc

#
################generate local_registry_images.yaml  with ceph extra services
  openstack overcloud container image prepare \
    --namespace=registry.access.redhat.com/rhosp13 \
    --prefix=openstack- \
    --tag=latest \
    --output-images-file /home/stack/local_registry_images.yaml \
    --set ceph_namespace=registry.access.redhat.com/rhceph \
    --set ceph_image=rhceph-3-rhel7 \
    --set ceph_tag=latest \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/octavia.yaml
######upload images #####
sudo openstack overcloud container image upload   --config-file  /home/stack/local_registry_images.yaml   --verbose
#############
openstack overcloud container image prepare \
        --namespace=172.16.1.40:8787/rhosp13 \
        --prefix=openstack- \
        --output-env-file=/home/stack/templates/docker-local-octavia.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/octavia.yaml \
        --set ceph_namespace=172.16.1.40:8787/rhceph \
        --set ceph_image=rhceph-3-rhel7

        -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml \
#####test repo############







#############
openstack overcloud container image prepare \
 --output-env-file templates/docker-local.yaml \
 --namespace registry.access.redhat.com/rhosp13 \
 --prefix openstack- \
 --push-destination=172.16.1.40:8787 \
 --output-images-file /home/stack/local_registry_images.yaml \
 -r /usr/share/openstack-tripleo-heat-templates/roles_data.yaml \
 -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
 -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
 -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml \
 --set ceph_namespace=registry.access.redhat.com/rhceph \
 --set ceph_image=rhceph-3-rhel7 \
 --set ceph_tag=latest
