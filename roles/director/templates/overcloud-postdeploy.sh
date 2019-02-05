cd /home/stack
source ~/overcloudrc
neutron net-create external --shared --router:external --provider:physical_network datacentre --provider:network_type flat
neutron subnet-create external 10.0.0.0/24 --name external --allocation-pool start=10.0.0.100,end=10.0.0.200   --gateway 10.0.0.1
neutron net-create private
neutron subnet-create private 192.168.100.0/24 --name private --dns-nameserver 8.8.8.8 --gateway 192.168.100.1
neutron router-create router
neutron router-gateway-set router external
neutron router-interface-add router private

nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
nova secgroup-list-rules default
openstack keypair create --public-key ~/.ssh/authorized_keys stack

wget -O images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2 https://download.fedoraproject.org/pub/fedora/linux/releases/24/CloudImages/x86_64/images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2
wget -O images/ubuntu-xenial.qcow2 https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
wget -O images/cirros.img http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img


openstack image create fedora24 --file images/Fedora-Cloud-Base-24-1.2.x86_64.qcow2 --disk-format qcow2 --container-format bare  --public
openstack image create ubuntu --file images/ubuntu-xenial.qcow2 --disk-format qcow2 --container-format bare  --public
openstack image create cirros --file images/cirros.img --disk-format qcow2 --container-format bare  --public


cat << EOF > cloud-init

#cloud-config
hostname: machine-fedora
fqdn: machine-fedora.lab.local
manage_etc_hosts: true
debug: true
package_upgrade: true
users:
  - default
  - name: stack
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: wheel,adm
    ssh_pwauth: True
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBuaErYJkQTbdE1NZovWf5hPanNR9liE9jeEf7gPw52kgStxy/ewX5JuFYSPQZN137G1HmIhk+FCa1XWfgL8GeTOtkHq/sIpYJChsK6QwxVd2/dQQLTrwmUgNLyM4brWQ7i0WhGeCDVIGCkvdkBOcPNaxJBb7vyt03ZemjnZhLXRQ== rsa-key-20050908
  - name: root
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBuaErYJkQTbdE1NZovWf5hPanNR9liE9jeEf7gPw52kgStxy/ewX5JuFYSPQZN137G1HmIhk+FCa1XWfgL8GeTOtkHq/sIpYJChsK6QwxVd2/dQQLTrwmUgNLyM4brWQ7i0WhGeCDVIGCkvdkBOcPNaxJBb7vyt03ZemjnZhLXRQ== rsa-key-20050908
ssh_pwauth: True
disable_root: false
chpasswd:
  list: |
    root:toor
    stack:stack
  expire: false
packages:
  - screen
  - git
EOF
openstack subnet  pool create --address-scope address-scope-ip4 --shared --pool-prefix 10.0.0.0/24 --default-prefixlen 26 subnet-pool-ip4
openstack server create   --flavor p1.medium  --image "fedora25" --key-name karim  --user-data cloud-init  --security-group default  --nic net-id=public fedora-makina-test
