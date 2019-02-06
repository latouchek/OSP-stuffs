#!/bin/bash

export USER=
export PASSWORD=
export POOLID=
export ROOTPASSWORD=toor # choose a root user password
export STACKPASSWORD=stack # choose a stack user password
virt-customize  -a rhel7-guest-official.qcow2 \
                 --run-command 'xfs_growfs /' \
                 --root-password password:$ROOTPASSWORD \
                 --sm-credentials $USER:password:$PASSWORD --sm-register --sm-attach auto  \
                 --run-command 'useradd stack' \
                 --password stack:password:$STACKPASSWORD \
                 --run-command 'echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack' \
                 --chmod 0440:/etc/sudoers.d/stack \
                 --run-command 'subscription-manager repos --disable=*' \
                 --run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config' \
                 --run-command 'systemctl enable sshd' \
                 --selinux-relabel

virt-customize  -a rhel7-guest-official.qcow2 \
                            --sm-credentials $USER:password:$PASSWORD --sm-register --sm-attach auto  \
                            --run-command 'echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack' \
                            --run-command 'subscription-manager repos --disable=*' \
                            --run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config' \
                            --run-command 'systemctl enable sshd'

virt-customize  -a rhel7-guest-official.qcow2 \
          --run-command 'echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack' \
          --run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config' \
          --run-command 'systemctl enable sshd' \
          --selinux-relabel

          virt-install --ram 16384 --vcpus 8 --os-variant rhel7 \
          --disk path=/var/lib/libvirt/images/reposerver2.qcow2,device=disk,bus=virtio,format=qcow2 \
          --import --noautoconsole --vnc \
          --network network:default \
          --cpu host-passthrough \
          --name reposerver2

export USER=
export PASSWORD=
export POOLID=
export ROOTPASSWORD=toor # choose a root user password
export STACKPASSWORD=stack # choose a stack user password
virt-customize  -a rhel7-guest-official.qcow2 \
                 --run-command 'xfs_growfs /' \
                 --root-password password:$ROOTPASSWORD \
                 --sm-credentials $USER:password:$PASSWORD  --sm-register --sm-attach auto \
                 --run-command 'useradd stack' \
                 --password stack:password:$STACKPASSWORD \
                 --run-command 'echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack' \
                 --chmod 0440:/etc/sudoers.d/stack \
                 --run-command 'subscription-manager repos --disable="*" --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.10-rpms" --enable="rhel-7-fast-datapath-rpms"' \
                 --run-command 'sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config' \
                 --run-command 'systemctl enable sshd'\
                 --update \
                 --selinux-relabel
