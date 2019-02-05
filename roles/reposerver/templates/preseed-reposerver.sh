#!/bin/bash

##modify sshd_config
# sed -i 's/[#]*PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

sed -i 's/^#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
echo "UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config > /dev/null
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config


cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
ONBOOT=yes
IPADDR={{reposerver_ip}}
NETMASK=255.255.255.0
GATEWAY=192.168.122.1
NM_CONTROLLED=no
DNS1=192.168.122.1
EOF

# subscription-manager register --username={{rhn_username}} --password={{rhn_password}}
# subscription-manager attach --pool={{pool}}
# subscription-manager repos --disable=*
# subscription-manager attach --pool={{pool}}


subscription-manager repos   --enable=rhel-7-server-extras-rpms \
                             --enable=rhel-7-fast-datapath-rpms \
                             --enable=rhel-7-server-openstack-13-rpms \
                             --enable=rhel-7-server-openstack-13-devtools-rpms \
                             --enable=rhel-7-server-openstack-13-optools-rpms \
                             --enable=rhel-7-server-rh-common-rpms \
                             --enable=rhel-7-server-rpms \
                             --enable=rhel-7-server-optional-rpms \
                             --enable=rhel-ha-for-rhel-7-server-rpms \
                             --enable=rhel-7-server-ose-3.10-rpms \
                             --enable=rhel-7-server-ansible-2.5-rpms \
                             --enable=rhel-7-server-rhceph-3-mon-rpms \
                             --enable=rhel-7-server-rhceph-3-tools-rpms \
                             --enable=rhel-7-server-rhceph-3-osd-rpms \
                             --enable=rhel-7-server-nfv-rpms
