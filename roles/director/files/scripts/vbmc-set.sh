
j=6229
for domain in $(virsh --connect qemu+ssh://root@192.168.122.1/system list --all | grep -v Name| grep overcloud | awk '{print $2}' )
do
 j=$((j + 1));   vbmc add $domain --port $j --username admin --password admin --libvirt-uri=qemu+ssh://root@192.168.122.1/system
 vbmc start $domain
done
