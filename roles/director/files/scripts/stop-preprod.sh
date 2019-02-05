clear
# MACHINE IP IDRAC
swift1_idrac=10.231.42.153
swift2_idrac=10.231.42.154
swift3_idrac=10.231.42.155
ceph3_idrac=10.231.42.146
ceph4_idrac=10.231.42.147
ceph5_idrac=10.231.42.148
ceph6_idrac=10.231.42.149
compute1_idrac=10.231.42.150
compute2_idrac=10.231.42.151
compute3_idrac=10.231.42.152

# IDRAC password
password_idrac=openstack
on="Chassis Power is on"
off="Chassis Power is on"

echo -e "\n Setting Openstack pre-prod nodes booting to PXE:"
echo "swift1: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift1_idrac  power off)
echo "swift2: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift2_idrac  power off)
echo "swift3: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift3_idrac  power off)
echo "compute1: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute1_idrac  power off)
echo "compute2: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute2_idrac  power off)
echo "compute3: "		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute3_idrac  power off)
echo "ceph3: "			$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph3_idrac  power off)
echo "ceph4: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph4_idrac  power off)
echo "ceph5: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph5_idrac  power off)
echo "ceph6: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph6_idrac  power off)


