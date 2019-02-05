source ~/stackrc

for i in `ironic node-list | awk 'NR>2' |awk '{print $2;}'`; do  ironic node-set-power-state  $i off ; done


for i in `ironic node-list | awk 'NR>2' |awk '{print $2;}'`; do ironic node-delete $i ; done


sudo rm -f /var/lib/ironic-discoverd/discoverd.sqlite

sudo systemctl restart openstack-ironic-inspector

sudo ironic-inspector-dbsync --config-file /etc/ironic-inspector/inspector.conf upgrade
