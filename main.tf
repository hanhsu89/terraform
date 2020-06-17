resource "vsphere_virtual_machine" "vm" {
  count            = "1"
  name             = "hungnv${count.index + 1}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus = 2
  memory   = 2048
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }


  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
customize {
      linux_options {
        host_name = "hung${count.index + 1}"
        domain    = "hung.local"
      }
network_interface {
        ipv4_address = "192.168.10.${206 + count.index}"
        ipv4_netmask = 24

      }
      ipv4_gateway = "192.168.10.1"
      dns_server_list = ["8.8.8.8"]

    }
  }
}

                      
