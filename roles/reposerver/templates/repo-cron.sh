#!/bin/bash
yum clean all

for i in  rhel-7-server-extras-rpms \
          rhel-7-fast-datapath-rpms \
          rhel-7-server-openstack-13-rpms \
          rhel-7-server-openstack-13-devtools-rpms \
          rhel-7-server-openstack-13-optools-rpms \
          rhel-7-server-rh-common-rpms \
          rhel-7-server-rpms \
          rhel-7-server-optional-rpms \
          rhel-ha-for-rhel-7-server-rpms \
          rhel-7-server-ose-3.10-rpms \
          rhel-7-server-ansible-2.5-rpms \
          rhel-7-server-rhceph-3-mon-rpms \
          rhel-7-server-rhceph-3-tools-rpms \
          rhel-7-server-rhceph-3-osd-rpms \
          rhel-7-server-nfv-rpms ;
         do reposync -n -d  -l --repoid=$i --download_path=/OSPOCP/ --downloadcomps --download-metadata
         done
for i in rhel-7-server-extras-rpms \
         rhel-7-fast-datapath-rpms \
         rhel-7-server-openstack-13-rpms \
         rhel-7-server-openstack-13-devtools-rpms \
         rhel-7-server-openstack-13-optools-rpms \
         rhel-7-server-rh-common-rpms \
         rhel-7-server-rpms \
         rhel-7-server-optional-rpms \
         rhel-ha-for-rhel-7-server-rpms \
         rhel-7-server-ose-3.10-rpms \
         rhel-7-server-ansible-2.5-rpms \
         rhel-7-server-rhceph-3-mon-rpms \
         rhel-7-server-rhceph-3-tools-rpms \
         rhel-7-server-rhceph-3-osd-rpms \
         rhel-7-server-nfv-rpms ;
         do createrepo -v /OSPOCP/$i -g comps.xml
         done
