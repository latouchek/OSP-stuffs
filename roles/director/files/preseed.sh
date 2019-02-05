#!/bin/bash

##modify sshd_config
# sed -i 's/[#]*PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config

sed -i 's/^#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
echo "UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config > /dev/null
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config

subscription-manager register --username=klatouch-tiger --password=Nitzerebb70%
subscription-manager attach --pool=8a85f9815698131901569837e21b57f4
subscription-manager repos --disable=*
subscription-manager repos --enable=rhel-7-server-beta-rpms \
                           --enable=rhel-7-server-extras-rpms \
                           --enable=rhel-7-server-rh-common-rpms \
                           --enable=rhel-ha-for-rhel-7-server-beta-rpms \
                           --enable=rhel-7-server-openstack-beta-rpms \
                           --enable=rhel-7-fast-datapath-rpms

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=192.168.122.253
NETMASK=255.255.255.0
GATEWAY=192.168.122.1
NM_CONTROLLED=no
DNS1=8.8.8.8
EOF
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth2
DEVICE=eth2
ONBOOT=yes
IPADDR=10.0.0.2
NETMASK=255.255.255.0
GATEWAY=10.0.0.1
NM_CONTROLLED=no
DNS1=8.8.8.8
EOF
