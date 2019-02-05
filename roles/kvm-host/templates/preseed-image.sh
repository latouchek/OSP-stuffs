#!/bin/bash



subscription-manager register --username=klatouch-tiger --password=Nitzerebb70%
# subscription-manager attach --pool=8a85f9815698131901569837e21b57f4
# subscription-manager repos --disable=*

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
name = rhel-7-server-openstack-10-devtools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-11-devtools-rpms
gpgcheck = 0
enabled = 1

[opstools]
name = rhel-7-server-openstack-11-optools-rpms
baseurl = http://{{reposerver_ip}}/OSP/rhel-7-server-openstack-11-optools-rpms
gpgcheck = 0
enabled = 1

EOF

yum update -y 
