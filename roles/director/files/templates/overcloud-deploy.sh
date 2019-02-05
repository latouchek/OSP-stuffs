#!/bin/bash

exec openstack overcloud deploy \
        --templates /usr/share/openstack-tripleo-heat-templates \
        --ntp-server ntp.ovh.net \
        --control-flavor control --control-scale 1 \
        --compute-flavor compute --compute-scale 3 \
        --ceph-storage-flavor ceph-storage --ceph-storage-scale 3 \
        -e ~/templates/first-boot-env.yaml \
        -e ~/templates/low-memory-usage.yaml \
        -e /home/stack/templates/network-environment.yaml \
        -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
        -e /home/stack/templates/storage-environment.yaml
