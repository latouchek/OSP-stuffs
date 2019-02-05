#!/bin/bash

exec openstack overcloud deploy \
        --templates /usr/share/openstack-tripleo-heat-templates \
        -e ~/templates/count-and-flavor.yaml \
        -r ~/templates/roles_data.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
        -e /home/stack/templates/ceph-custom-configv2.yaml \
        -e ~/templates/overcloud_images.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
        -e /home/stack/templates/network-environment.yaml \
        -e ~/templates/first-boot-env.yaml \
        -e ~/templates/low-memory-usage.yaml \
        --ntp-server ntp.ovh.net \
        --timeout 120
