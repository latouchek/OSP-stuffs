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
IPADDR=192.168.122.3
NETMASK=255.255.255.0
GATEWAY=192.168.122.1
NM_CONTROLLED=no
DNS1=8.8.8.8
EOF
