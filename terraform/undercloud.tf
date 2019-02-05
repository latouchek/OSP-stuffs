# instance the provider
provider "libvirt" {
  uri = "qemu+ssh://root@kvm-ovh/system"
}

# We fetch the latest fedora release image from their mirrors
resource "libvirt_volume" "undercloud14" {
  name   = "undercloud-rhsec"
  pool   = "images"
  source = "https://access.cdn.redhat.com/content/origin/files/sha256/3b/3b356c54d6927a7c16b10862e7b09f0d7ed0071a53f90c9f411f4e255c24f918/rhel-server-7.6-x86_64-kvm.qcow2?user=e3882d238758d55a7413c63548cf8fb1&_auth_=1548260203_9b22ac487ecab51716c472c0b192f362"
  format = "qcow2"
}
# resource "libvirt_volume" "volume2" {
#   name   = "volume2"
#   pool   = "images"
#   size   = "500000000"
#   format = "qcow2"
# }
resource "libvirt_volume" "disk_rhel_resized" {
  name           = "disk"
  base_volume_id = "${libvirt_volume.undercloud14.id}"
  pool           = "images"
  size           = 55361393152
}
data "template_file" "user_data" {
  template = "${file("${path.module}/cloud-init-osp14-undercloud")}"
}

data "template_file" "network_config" {
  template = "${file("${path.module}/network_config.cfg")}"
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "cloudinit14" {
  name           = "cloudinit14.iso"
  pool           = "images"
  user_data      = "${data.template_file.user_data.rendered}"
  network_config = "${data.template_file.network_config.rendered}"
}

# Create the machine
resource "libvirt_domain" "domain-undercloud14" {
  name   = "undercloud14-anssi"
  memory = "32768"
  vcpu   = 8

  cloudinit = "${libvirt_cloudinit_disk.cloudinit14.id}"

  network_interface {
    network_name = "vlan102"
  }
  network_interface {
    network_name = "default"
  }
  network_interface {
    network_name = "vlan108"
  }
  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = "${libvirt_volume.disk_rhel_resized.id}"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
# output "ip" {
#   value = "${libvirt_domain.domain-undercloud13.network_interface.1.addresses.0}"
# }
