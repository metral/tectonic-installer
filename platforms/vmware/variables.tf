// # VMware Connectivity

variable "tectonic_vmware_vm_template" {
  type        = "string"
  description = "Virtual Machine template of CoreOS Container Linux."
}

variable "tectonic_vmware_vm_template_folder" {
  type        = "string"
  description = "Folder for VM template of CoreOS Container Linux."
}

variable "tectonic_vmware_server" {
  type        = "string"
  description = "vCenter Server IP/FQDN"
}

variable "tectonic_vmware_sslselfsigned" {
  type        = "string"
  description = "Is the vCenter certificate Self-Signed? Example: `tectonic_vmware_sslselfsigned = \"true\"` "
}

variable "tectonic_vmware_folder" {
  type        = "string"
  description = "vSphere Folder to create and add the Tectonic nodes"
}

variable "tectonic_vmware_network" {
  type        = "string"
  description = "Portgroup to attach the cluster nodes"
}

variable "tectonic_vmware_cluster" {
  type        = "string"
  description = "vCenter Cluster used to create VMs under"
}

variable "tectonic_vmware_resource_pool" {
  type        = "string"
  description = "(optional) The name of a Resource Pool in which to launch the virtual machine. Requires full path. Full path can be obtained by executing `govc pool.info $ResourcePoolName`"
  default     = ""
}

// # Global

variable "tectonic_vmware_ssh_authorized_key" {
  type        = "string"
  description = "SSH public key to use as an authorized key. Example: `\"ssh-rsa AAAB3N...\"`"
}

variable "tectonic_vmware_ssh_private_key_path" {
  type        = "string"
  description = "SSH private key file in .pem format corresponding to tectonic_vmware_ssh_authorized_key. If not provided, SSH agent will be used."
  default     = ""
}

variable "tectonic_vmware_node_dns" {
  type        = "string"
  description = "DNS Server to be used by Virtual Machine(s). Multiple DNS servers can be separated by whitespace. Example: `\"192.168.1.1 192.168.2.1\"`"
}

variable "tectonic_vmware_controller_domain" {
  type        = "string"
  description = "The domain name which resolves to controller node(s)"
}

variable "tectonic_vmware_ingress_domain" {
  type        = "string"
  description = "The domain name which resolves to Tectonic Ingress (i.e. worker node(s))"
}

// # Node Settings

// ## ETCD

variable "tectonic_vmware_etcd_vcpu" {
  type        = "string"
  default     = "1"
  description = "etcd node(s) VM vCPU count"
}

variable "tectonic_vmware_etcd_memory" {
  type        = "string"
  default     = "4096"
  description = "etcd node(s) VM Memory Size in MB"
}

variable "tectonic_vmware_etcd_hostnames" {
  type = "map"

  description = <<EOF
  Terraform map of etcd node(s) Hostnames, Example:
  tectonic_vmware_etcd_hostnames = {
  "0" = "mycluster-etcd-0"
  "1" = "mycluster-etcd-1"
  "2" = "mycluster-etcd-2"
}
eof
}

variable "tectonic_vmware_etcd_datacenters" {
  type = "map"

  description = <<EOF
  terraform map of etcd node(s) Virtual DataCenters, example:
  tectonic_vmware_etcd_datacenters = {
  "0" = "myvmwaredc-0"
  "1" = "myvmwaredc-1"
  "2" = "myvmwaredc-2"
}
EOF
}

variable "tectonic_vmware_etcd_ip" {
  type = "map"

  description = <<EOF
  Terraform map of etcd node(s) IP Addresses, Example:
  tectonic_vmware_etcd_ip = {
  "0" = "192.168.246.10/24"
  "1" = "192.168.246.11/24"
  "2" = "192.168.246.12/24"
}
EOF
}

variable "tectonic_vmware_etcd_gateway" {
  type        = "string"
  description = "Default Gateway IP address for etcd nodes(s)"
}

variable "tectonic_vmware_etcd_datastore" {
  type        = "string"
  default     = ""
  description = "The storage LUN used by etcd nodes. In order to use vSphere Datastore Cluster use the syntax DatastoreClusterName/datastore."
}

// ## Masters

variable "tectonic_vmware_master_vcpu" {
  type        = "string"
  default     = "1"
  description = "Master node(s) vCPU count"
}

variable "tectonic_vmware_master_memory" {
  type        = "string"
  default     = "4096"
  description = "Master node(s) Memory Size in MB"
}

variable "tectonic_vmware_master_hostnames" {
  type = "map"

  description = <<EOF
  Terraform map of Master node(s) Hostnames, Example:
  tectonic_vmware_master_hostnames = {
  "0" = "mycluster-master-0"
  "1" = "mycluster-master-1"
}
EOF
}

variable "tectonic_vmware_master_datacenters" {
  type = "map"

  description = <<EOF
  terraform map of master node(s) Virtual DataCenters, example:
  tectonic_vmware_master_datacenters = {
  "0" = "myvmwaredc-0"
  "1" = "myvmwaredc-1"
  "2" = "myvmwaredc-2"
}
EOF
}

variable "tectonic_vmware_master_ip" {
  type = "map"

  description = <<EOF
  Terraform map of Master node(s) IP Addresses, Example: 
  tectonic_vmware_master_ip = {
  "0" = "192.168.246.20/24"
  "1" = "192.168.246.21/24"
}
EOF
}

variable "tectonic_vmware_master_gateway" {
  type        = "string"
  description = "Default Gateway IP address for Master nodes(s)"
}

variable "tectonic_vmware_master_datastore" {
  type        = "string"
  default     = ""
  description = "The storage LUN used by master nodes. In order to use vSphere Datastore Cluster use the syntax DatastoreClusterName/datastore."
}

// ## Workers

variable "tectonic_vmware_worker_vcpu" {
  type        = "string"
  default     = "1"
  description = "Worker node(s) vCPU count"
}

variable "tectonic_vmware_worker_memory" {
  type        = "string"
  default     = "4096"
  description = "Worker node(s) Memory Size in MB"
}

variable "tectonic_vmware_worker_hostnames" {
  type = "map"

  description = <<EOF
  Terraform map of Worker node(s) Hostnames, Example: 
  tectonic_vmware_worker_hostnames = {
  "0" = "mycluster-worker-0"
  "1" = "mycluster-worker-1"
}
EOF
}

variable "tectonic_vmware_worker_datacenters" {
  type = "map"

  description = <<EOF
  terraform map of worker node(s) Virtual DataCenters, example:
  tectonic_vmware_worker_datacenters = {
  "0" = "myvmwaredc-0"
  "1" = "myvmwaredc-1"
}
EOF
}

variable "tectonic_vmware_worker_ip" {
  type = "map"

  description = <<EOF
  Terraform map of Worker node(s) IP Addresses, Example: 
  tectonic_vmware_worker_ip = {
  "0" = "192.168.246.30/24"
  "1" = "192.168.246.31/24"
}
EOF
}

variable "tectonic_vmware_worker_gateway" {
  type        = "string"
  description = "Default Gateway IP address for Master nodes(s)"
}

variable "tectonic_vmware_worker_datastore" {
  type        = "string"
  default     = ""
  description = "The storage LUN used by worker nodes. In order to use vSphere Datastore Cluster use the syntax DatastoreClusterName/datastore."
}

variable "tectonic_vmware_nfs_enabled" {
  type        = "string"
  default     = "false"
  description = "enable NFS mount"
}

variable "tectonic_vmware_iscsi_enabled" {
  type        = "string"
  default     = "false"
  description = "enable iSCSI connections"
}

variable "tectonic_trusted_ca" {
  type        = "string"
  description = "Path to CA to add to trusted CAs on cluster nodes"
}
