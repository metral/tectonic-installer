data "template_file" "scripts_generate_node_dns_configmap" {
  template = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: node-dns-cfg
  namespace: node-dns
  labels:
    tier: node
    app: node-dns
data:
  node-dns.sh: |
    #!/bin/bash

    # DNS settings
    BASE_DOMAIN="$${base_domain}"
    NAMESERVER="$${dns_server}"

    # IP addr for the host machine of the Pod
    HOST_IP=`ip -4 a s eth0 | grep inet | awk '{print $2}' | cut -d "/" -f 1`

    # Overwrite DNS resolver
    cp /etc/resolv.conf /etc/resolv.conf.`date +%s`
    rm /etc/resolv.conf

    cat > /etc/resolv.conf <<END
    nameserver $NAMESERVER
    search $BASE_DOMAIN
    END

    ## update the DNS records
    cat > /etc/node-dns-records.txt <<-END
    update delete $HOSTNAME.$BASE_DOMAIN A
    update add $HOSTNAME.$BASE_DOMAIN 0 A $HOST_IP
    send
    END

    nsupdate -d /etc/node-dns-records.txt

    # Rekick kubelet to flush DNS cache
    kill `pidof kubelet`

    while true
    do
      sleep 1
    done
EOF

  vars {
    base_domain = "${var.base_domain}"
    dns_server  = "${var.dns_server}"
  }
}

resource "local_file" "generate_node_dns_configmap" {
  content  = "${data.template_file.scripts_generate_node_dns_configmap.rendered}"
  filename = "${path.cwd}/generated/dns/node-dns-configmap.yaml"
}
