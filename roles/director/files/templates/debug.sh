openstack stack resource list -n5 overcloud | grep -v _COMPLETE | awk '/OS::/ {print $12,$2,$4}' | while read line; do
 stack="`echo $line|cut -d\  -f1`"
 resource="`echo $line|cut -d\  -f2`"
 physid="`echo $line|cut -d\  -f3`"
 openstack stack resource show "$stack" "$resource"
 echo
 openstack software deployment output show $physid --all --long
 echo
done
