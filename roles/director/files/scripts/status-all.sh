clear
# MACHINE IP IDRAC
swift1_idrac=10.231.42.153
swift2_idrac=10.231.42.154
swift3_idrac=10.231.42.155
ceph1_idrac=10.231.42.144
ceph2_idrac=10.231.42.145
ceph3_idrac=10.231.42.146
ceph4_idrac=10.231.42.147
ceph5_idrac=10.231.42.148
ceph6_idrac=10.231.42.149
compute1_idrac=10.231.42.150
compute2_idrac=10.231.42.151
compute3_idrac=10.231.42.152
controller1_idrac=10.231.42.156
controller2_idrac=10.231.42.157
controller3_idrac=10.231.42.158

# IDRAC password
password_idrac=openstack
on="Chassis Power is on"
off="Chassis Power is on"

echo "connect to IPMI to check server status"
#       1. controller1
#       2. controller2
#       3. controller3
#       4. start swift
#       5. start ceph
#       6. start compute
echo "Admin-Host:"
echo "ceph1: "  $(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph1_idrac  power status)

echo "Director-Host:"
echo "ceph2: "  $(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph2_idrac  power status)

echo -e "\nOpenstack pre-prod:"
echo "controller"
echo "swift1: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift1_idrac  power status)
echo "swift2: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift2_idrac  power status)
echo "swift3: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $swift3_idrac  power status)
echo "compute"
echo "compute1: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute1_idrac  power status)
echo "compute2: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute2_idrac  power status)
echo "compute3: "		$(ipmitool -I lanplus -U admin -P $password_idrac -H $compute3_idrac  power status)
echo "ceph"
echo "ceph3: "			$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph3_idrac  power status)
echo "ceph4: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph4_idrac  power status)
echo "ceph5: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph5_idrac  power status)
echo "ceph6: "  		$(ipmitool -I lanplus -U admin -P $password_idrac -H $ceph6_idrac  power status)

echo -e "\nVMWARE:"
echo "controller1: "  $(ipmitool -I lanplus -U admin -P $password_idrac -H $controller1_idrac  power status)
echo "controller2: "  $(ipmitool -I lanplus -U admin -P $password_idrac -H $controller2_idrac  power status)

echo -e "\nOpenstack AIO:"
echo "controller3: "  $(ipmitool -I lanplus -U admin -P $password_idrac -H $controller3_idrac  power status)

