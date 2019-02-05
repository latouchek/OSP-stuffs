cp -r /usr/share/openstack-tripleo-heat-templates/network/config/bond-with-vlans templates/nic-configs
cd templates
cat << EOF > network-environment.yaml
resource_registry:
  OS::TripleO::BlockStorage::Net::SoftwareConfig: /home/stack/templates/nic-configs/cinder-storage.yaml
  OS::TripleO::Compute::Net::SoftwareConfig: /home/stack/templates/nic-configs/compute.yaml
  OS::TripleO::Controller::Net::SoftwareConfig: /home/stack/templates/nic-configs/controller.yaml
  OS::TripleO::ObjectStorage::Net::SoftwareConfig: /home/stack/templates/nic-configs/swift-storage.yaml
  OS::TripleO::CephStorage::Net::SoftwareConfig: /home/stack/templates/nic-configs/ceph-storage.yaml

parameter_defaults:
  # This sets 'external_network_bridge' in l3_agent.ini to an empty string
  # so that external networks act like provider bridge networks (they
  # will plug into br-int instead of br-ex)
  NeutronExternalNetworkBridge: "''"

  # Internal API used for private OpenStack Traffic
  InternalApiNetCidr: 172.17.1.0/24
  InternalApiAllocationPools: [{'start': '172.17.1.10', 'end': '172.17.1.200'}]
  InternalApiNetworkVlanID: 101

  # Tenant Network Traffic - will be used for VXLAN over VLAN
  TenantNetCidr: 172.17.2.0/24
  TenantAllocationPools: [{'start': '172.17.2.10', 'end': '172.17.2.200'}]
  TenantNetworkVlanID: 201

  # Public Storage Access - e.g. Nova/Glance <--> Ceph
  StorageNetCidr: 172.17.3.0/24
  StorageAllocationPools: [{'start': '172.17.3.10', 'end': '172.17.3.200'}]
  StorageNetworkVlanID: 301

  # Private Storage Access - i.e. Ceph background cluster/replication
  StorageMgmtNetCidr: 172.17.4.0/24
  StorageMgmtAllocationPools: [{'start': '172.17.4.10', 'end': '172.17.4.200'}]
  StorageMgmtNetworkVlanID: 401

  # External Networking Access - Public API Access
  ExternalNetCidr: 192.168.122.0/24
  # Leave room for floating IPs in the External allocation pool (if required)
  ExternalAllocationPools: [{'start': '192.168.122.100', 'end': '192.168.122.129'}]
  # Set to the router gateway on the external network
  ExternalInterfaceDefaultRoute: 192.168.122.1

  # Add in configuration for the Control Plane
  ControlPlaneSubnetCidr: "24"
  ControlPlaneDefaultRoute: 192.0.2.1
  EC2MetadataIp: 192.0.2.1
  DnsServers: ['192.168.122.1', '8.8.8.8']

  # Bonding options (only active/backup works in a virtual environment)
  BondInterfaceOvsOptions: 'mode=1 miimon=150'
EOF
cp /usr/share/openstack-tripleo-heat-templates/network/config/bond-with-vlans/controller.yaml controller.yaml

sudo patch -p0  << EOF
--- controller-orig.yaml  2016-09-06 14:43:02.000000000 -0400
+++ nic-configs/controller.yaml 2016-09-22 17:51:39.029122104 -0400
@@ -117,6 +117,13 @@
               type: ovs_bridge
               name: {get_input: bridge_name}
               dns_servers: {get_param: DnsServers}
+              addresses:
+                -
+                  ip_netmask: {get_param: ExternalIpSubnet}
+              routes:
+                -
+                  default: true
+                  next_hop: {get_param: ExternalInterfaceDefaultRoute}
               members:
                 -
                   type: ovs_bond
@@ -133,17 +140,6 @@
                 -
                   type: vlan
                   device: bond1
-                  vlan_id: {get_param: ExternalNetworkVlanID}
-                  addresses:
-                    -
-                      ip_netmask: {get_param: ExternalIpSubnet}
-                  routes:
-                    -
-                      default: true
-                      next_hop: {get_param: ExternalInterfaceDefaultRoute}
-                -
-                  type: vlan
-                  device: bond1
                   vlan_id: {get_param: InternalApiNetworkVlanID}
                   addresses:
                     -
EOF
sudo cp controller.yaml /usr/share/openstack-tripleo-heat-templates/network/config/bond-with-vlans/controller.yaml
for Y in nic-configs/*.yaml; \
    do sed -i 's/type: ovs_bond/type: linux_bond/' $Y; done
for Y in nic-configs/*.yaml; \
        do sed -i 's/ovs_options:/bonding_options:/' $Y ; done


cat << EOF >> HostnameMap.yaml
  parameter_defaults:
    HostnameMap:
      overcloud-controller-0: lab-controller01
      overcloud-controller-1: lab-controller02
      overcloud-controller-2: lab-controller03
      overcloud-compute-0: lab-compute01
      overcloud-compute-1: lab-compute02
      overcloud-cephstorage-0: lab-ceph01
      overcloud-cephstorage-1: lab-ceph02
      overcloud-cephstorage-2: lab-ceph03
EOF
cat << EOF >> ips-from-pool-all.yaml
# Environment file demonstrating how to pre-assign IPs to all node types
resource_registry:
  OS::TripleO::Controller::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/external_from_pool.yaml
  OS::TripleO::Controller::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/internal_api_from_pool.yaml
  OS::TripleO::Controller::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_from_pool.yaml
  OS::TripleO::Controller::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_mgmt_from_pool.yaml
  OS::TripleO::Controller::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/tenant_from_pool.yaml
  # Management network is optional and disabled by default
  #OS::TripleO::Controller::Ports::ManagementPort: /usr/share/openstack-tripleo-heat-templates/network/ports/management_from_pool.yaml

  OS::TripleO::Compute::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Compute::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/internal_api_from_pool.yaml
  OS::TripleO::Compute::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_from_pool.yaml
  OS::TripleO::Compute::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Compute::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/tenant_from_pool.yaml
  #OS::TripleO::Compute::Ports::ManagementPort: /usr/share/openstack-tripleo-heat-templates/network/ports/management_from_pool.yaml

  OS::TripleO::CephStorage::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::CephStorage::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::CephStorage::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_from_pool.yaml
  OS::TripleO::CephStorage::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_mgmt_from_pool.yaml
  OS::TripleO::CephStorage::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  #OS::TripleO::CephStorage::Ports::ManagementPort: /usr/share/openstack-tripleo-heat-templates/network/ports/management_from_pool.yaml

  OS::TripleO::SwiftStorage::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::SwiftStorage::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/internal_api_from_pool.yaml
  OS::TripleO::SwiftStorage::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_from_pool.yaml
  OS::TripleO::SwiftStorage::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_mgmt_from_pool.yaml
  OS::TripleO::SwiftStorage::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  #OS::TripleO::SwiftStorage::Ports::ManagementPort: /usr/share/openstack-tripleo-heat-templates/network/ports/management_from_pool.yaml

  OS::TripleO::BlockStorage::Ports::ExternalPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::BlockStorage::Ports::InternalApiPort: /usr/share/openstack-tripleo-heat-templates/network/ports/internal_api_from_pool.yaml
  OS::TripleO::BlockStorage::Ports::StoragePort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_from_pool.yaml
  OS::TripleO::BlockStorage::Ports::StorageMgmtPort: /usr/share/openstack-tripleo-heat-templates/network/ports/storage_mgmt_from_pool.yaml
  OS::TripleO::BlockStorage::Ports::TenantPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  #OS::TripleO::BlockStorage::Ports::ManagementPort: /usr/share/openstack-tripleo-heat-templates/network/ports/management_from_pool.yaml

### VIPS ###

  OS::TripleO::Network::Ports::NetVipMap: /usr/share/openstack-tripleo-heat-templates/network/ports/net_vip_map_external.yaml
  OS::TripleO::Network::Ports::ExternalVipPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Network::Ports::InternalApiVipPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Network::Ports::StorageVipPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml
  OS::TripleO::Network::Ports::StorageMgmtVipPort: /usr/share/openstack-tripleo-heat-templates/network/ports/noop.yaml


parameter_defaults:
  ControllerIPs:
    # Each controller will get an IP from the lists below, first controller, first IP
    external:
    - 192.168.122.201
    - 192.168.122.202
    - 192.168.122.203
    internal_api:
    - 172.17.1.201
    - 172.17.1.202
    - 172.17.1.203
    storage:
    - 172.17.3.201
    - 172.17.3.202
    - 172.17.3.203
    storage_mgmt:
    - 172.17.4.201
    - 172.17.4.202
    - 172.17.4.203
    tenant:
    - 172.17.2.201
    - 172.17.2.202
    - 172.17.2.203
    #management:
    #- 172.16.4.251
  NovaComputeIPs:
    # Each compute will get an IP from the lists below, first compute, first IP
    internal_api:
    - 172.17.1.211
    - 172.17.1.212
    storage:
    - 172.17.3.211
    - 172.17.3.212
    tenant:
    - 172.17.2.211
    - 172.17.2.212
    #management:
    #- 172.16.4.252
  CephStorageIPs:
    # Each ceph node will get an IP from the lists below, first node, first IP
    storage:
    - 172.17.3.221
    - 172.17.3.222
    - 172.17.3.223
    storage_mgmt:
    - 172.17.4.221
    - 172.17.4.222
    - 172.17.4.223

### VIPs ###

  ControlPlaneIP: 192.0.2.250
  ExternalNetworkVip: 192.168.122.150
  InternalApiNetworkVip: 172.17.1.150
  StorageNetworkVip: 172.17.3.150
  StorageMgmtNetworkVip: 172.17.4.150
EOF

cp /usr/share/openstack-tripleo-heat-templates/environments/storage-environment.yaml .
sed -i 's#../puppet/services#/usr/share/openstack-tripleo-heat-templates/puppet/services#' storage-environment.yaml

cat << EOF >> storage-environment.yaml

  ExtraConfig:
    ceph::profile::params::osds:
      '/dev/vdb': {}
EOF

cat << 'EOF' > wipe-disk.sh
#!/bin/bash

if [[ `hostname` = *"ceph"* ]]
then
  echo "Number of disks detected: $(lsblk -no NAME,TYPE,MOUNTPOINT | grep "disk" | awk '{print $1}' | wc -l)"
  for DEVICE in `lsblk -no NAME,TYPE,MOUNTPOINT | grep "disk" | awk '{print $1}'`
  do
    ROOTFOUND=0
    echo "Checking /dev/$DEVICE..."
    echo "Number of partitions on /dev/$DEVICE: $(expr $(lsblk -n /dev/$DEVICE | awk '{print $7}' | wc -l) - 1)"
    for MOUNTS in `lsblk -n /dev/$DEVICE | awk '{print $7}'`
    do
      if [ "$MOUNTS" = "/" ]
      then
        ROOTFOUND=1
      fi
    done
    if [ $ROOTFOUND = 0 ]
    then
      echo "Root not found in /dev/${DEVICE}"
      echo "Wiping disk /dev/${DEVICE}"
      sgdisk -Z /dev/${DEVICE}
      sgdisk -g /dev/${DEVICE}
    else
      echo "Root found in /dev/${DEVICE}"
    fi
  done
fi
EOF

cat << EOF > wipe-disks.yaml
heat_template_version: 2014-10-16

description: >
  Wipe and convert all disks to GPT (except the disk containing the root file system)

resources:
  userdata:
    type: OS::Heat::MultipartMime
    properties:
      parts:
      - config: {get_resource: wipe_disk}

  wipe_disk:
    type: OS::Heat::SoftwareConfig
    properties:
      config: {get_file: wipe-disk.sh}

outputs:
  OS::stack_id:
    value: {get_resource: userdata}
EOF

sudo patch -p0 << EOF
--- storage-environment.yaml       2016-09-22 18:28:48.959122104 -0400
+++ storage-environment.yaml    2016-09-22 16:39:21.790122104 -0400
@@ -6,6 +6,8 @@
   OS::TripleO::Services::CephOSD: /usr/share/openstack-tripleo-heat-templates/puppet/services/ceph-osd.yaml
   OS::TripleO::Services::CephClient: /usr/share/openstack-tripleo-heat-templates/puppet/services/ceph-client.yaml

+  OS::TripleO::NodeUserData: /home/stack/templates/wipe-disks.yaml
+
 parameter_defaults:

   #### BACKEND SELECTION ####
EOF

cat << 'EOF' > overcloud-deploy.sh
#!/bin/bash

exec openstack overcloud deploy \
        --templates /usr/share/openstack-tripleo-heat-templates \
        --ntp-server ntp.ovh.net \
        --control-flavor control --control-scale 3 \
        --compute-flavor compute --compute-scale 2 \
        --ceph-storage-flavor ceph-storage --ceph-storage-scale 3 \
        --neutron-tunnel-types vxlan --neutron-network-type vxlan \
        -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
        -e /home/stack/templates/network-environment.yaml \
        -e /home/stack/templates/HostnameMap.yaml \
        -e /home/stack/templates/ips-from-pool-all.yaml \
        -e /home/stack/templates/storage-environment.yaml
EOF
chmod 0755 overcloud-deploy.sh
