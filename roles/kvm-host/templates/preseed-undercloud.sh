#!/bin/bash

#modify sshd_config
ip=`echo {{local_ip}} | awk -F. '{ printf $1"."$2"."$3"."$4 }'`
version="{{version}}"
sed -i 's/^#   StrictHostKeyChecking ask/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
echo "UserKnownHostsFile=/dev/null" | sudo tee -a /etc/ssh/ssh_config > /dev/null
sed -i 's/#UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config


if [ $version = "10" ]
then
cat << EOF > /etc/yum.repos.d/OSP.repo
[extras]
name = rhel-7-server-extras-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-extras-rpms
gpgcheck = 0
enabled = 1

[OSP]
name = rhel-7-server-openstack-10-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-10-rpms
gpgcheck = 0
enabled = 1

[common]
name = rhel-7-server-rh-common-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rh-common-rpms
gpgcheck = 0
enabled = 1

[server]
name = rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[ha]
name = rhel-ha-for-rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-ha-for-rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[tools]
name = rhel-7-server-openstack-10-devtools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-10-devtools-rpms
gpgcheck = 0
enabled = 1

[opstools]
name = rhel-7-server-openstack-10-optools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-10-optools-rpms
gpgcheck = 0
enabled = 1

EOF
elif [ $version == "11" ]
then
cat << EOF > /etc/yum.repos.d/OSP.repo
[extras]
name = rhel-7-server-extras-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-extras-rpms
gpgcheck = 0
enabled = 1

[OSP]
name = rhel-7-server-openstack-11-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-11-rpms
gpgcheck = 0
enabled = 1

[common]
name = rhel-7-server-rh-common-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rh-common-rpms
gpgcheck = 0
enabled = 1

[server]
name = rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[ha]
name = rhel-ha-for-rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-ha-for-rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[tools]
name = rhel-7-server-openstack-11-devtools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-11-devtools-rpms
gpgcheck = 0
enabled = 1

[opstools]
name = rhel-7-server-openstack-11-optools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-11-optools-rpms
gpgcheck = 0
enabled = 1

EOF
elif [ $version == "12" ]
then
cat << EOF > /etc/yum.repos.d/OSP.repo
[extras]
name = rhel-7-server-extras-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-extras-rpms
gpgcheck = 0
enabled = 1

[OSP]
name = rhel-7-server-openstack-12-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-12-rpms
gpgcheck = 0
enabled = 1

[common]
name = rhel-7-server-rh-common-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rh-common-rpms
gpgcheck = 0
enabled = 1

[server]
name = rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[ha]
name = rhel-ha-for-rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-ha-for-rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[tools]
name = rhel-7-server-openstack-12-devtools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-12-devtools-rpms
gpgcheck = 0
enabled = 1

[opstools]
name = rhel-7-server-openstack-12-optools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-12-optools-rpms
gpgcheck = 0
enabled = 1


EOF

elif [ $version == "13" ]
then
cat << EOF > /etc/yum.repos.d/OSP.repo
[extras]
name = rhel-7-server-extras-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-extras-rpms
gpgcheck = 0
enabled = 1

[OSP]
name = rhel-7-server-openstack-13-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-13-rpms
gpgcheck = 0
enabled = 1

[tools]
name = rhel-7-server-openstack-13-devtools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-13-devtools-rpms
gpgcheck = 0
enabled = 1

[common]
name = rhel-7-server-rh-common-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rh-common-rpms
gpgcheck = 0
enabled = 1

[server]
name = rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-rpms
gpgcheck = 0
enabled = 1

[ha]
name = rhel-ha-for-rhel-7-server-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-ha-for-rhel-7-server-rpms
gpgcheck = 0
enabled = 1


EOF

fi

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=192.168.122.2
NETMASK=255.255.255.0
GATEWAY=192.168.122.1
NM_CONTROLLED=no
DNS1=192.168.122.1
EOF

# cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth2.205
# DEVICE=eth2.205
# ONBOOT=yes
# BOOTPROTO=none
# IPADDR=172.20.0.2
# NETWORK=172.20.0.0
# PREFIX=24
# NM_CONTROLLED=no
# VLAN=yes
# EOF
