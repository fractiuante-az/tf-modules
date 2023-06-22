resource "null_resource" "get_private_cluster_ip_address_script" {
  triggers = { always_run = "${timestamp()}" }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<-EOT
    set -e
    RgName="rg-itis-dev-rp-aks";
    VnetName="vnet-dev-itis-vpn-gatew-gwc";
    SubnetName="cluster-subnet";
    az version;
    az network vnet subnet list-available-ips --resource-group $RgName --vnet-name $VnetName -n $SubnetName
    EOT

  }
}
