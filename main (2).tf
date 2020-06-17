provider "vsphere" {
  user           = "administrator@vcenter.local"
  password       = "Hung6998@@"
  vsphere_server = "192.168.10.205"

  allow_unverified_ssl = true
}


data "vsphere_datacenter" "dc" {
  name = "Datacenter
"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore
"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "New Cluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "host" {
  name          = "192.168.10.224"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_virtual_machine" "template" {
  name          = "VM-Test1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm-node" {
  name = "hung${4 + count.index }"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  count = "2"
  num_cpus = "2"
  memory = "2048"
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"


  network_interface {
   network_id = "${data.vsphere_network.network.id}"
   adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = 100
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
    clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name  = "hung-nv${1 + count.index}"
        domain    = "hung.com"
      }

      network_interface {
        ipv4_address = "192.168.10.${111 + count.index}"
        ipv4_netmask = 24


      }
      dns_server_list = ["8.8.8.8"]
      ipv4_gateway = "192.168.10.1"

 
    }
  }
}



