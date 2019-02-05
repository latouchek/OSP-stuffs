openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 fatcompute
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="fatcompute" fatcompute


openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 osdcompute
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="osdcompute" osdcompute

openstack flavor create --id auto --ram 4096 --disk 40 --vcpus 1 networker
openstack flavor set --property "cpu_arch"="x86_64" --property "capabilities:boot_option"="local" --property "capabilities:profile"="networker" networker
