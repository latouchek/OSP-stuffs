#!/bin/bash

exec openstack overcloud deploy \
        --templates /usr/share/openstack-tripleo-heat-templates \
        -r ~/templates/roles_data.yaml \
        -e /home/stack/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
        -e ~/templates/count-and-flavor.yaml \
        -e ~/templates/overcloud_images.yaml \
        -e /home/stack/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
        -e /home/stack/templates/network-environment.yaml \
        -e /home/stack/templates/ceph-custom-configv2.yaml \
        -e ~/templates/first-boot-env.yaml \
        --ntp-server ntp.ovh.net \
        --timeout 120


        # --control-flavor control --control-scale 1 \
        # --compute-flavor compute --compute-scale 3 \
        # --ceph-storage-flavor ceph-storage --ceph-storage-scale 3 \
        # -e /home/stack/templates/hyperconverged-ceph.yaml \
        # -e /home/stack/templates/neutron-ovs-dvr.yaml \
        # -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
