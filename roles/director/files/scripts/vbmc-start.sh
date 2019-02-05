

for domain in $(virsh --connect qemu+ssh://stack@192.168.122.1/system list --all | grep -v Name| grep overcloud | awk '{print $2}' )
do
 vbmc start $domain
done
