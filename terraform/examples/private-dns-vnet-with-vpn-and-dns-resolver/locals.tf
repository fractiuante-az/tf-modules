locals {
  identifier                                = "private-dns-example"
  private_domain_name                       = "sample-dns.de"
  vpn_gateway_ip_prefix_pool_address_spaces = ["172.16.201.0/24"]

  endpoint_inbound_subnets = [{
    name              = "DNSibndSubnet0"
    type              = "private"
    subnet_delegation = true
    }, {
    name              = "DNSibndSubnet1"
    type              = "private"
    subnet_delegation = true
  }]

  endpoint_outbound_subnets = [
    {
      name              = "DNSobndSubnet0"
      type              = "private"
      subnet_delegation = true
      }, {
      name              = "DNSobndSubnet1"
      type              = "private"
      subnet_delegation = true
  }]

  endpoint_subnets = concat(local.endpoint_inbound_subnets, local.endpoint_outbound_subnets)

  # inbound_endpoints = [
  #   {
  #     subnet_id = ""
  #   }
  # ]

  # inbound_endpoints       = { for endpoint in var.inbound_endpoints : format("%s-%s", endpoint.name, "inbe") => endpoint }
  # outbound_endpoints      = { for endpoint in var.outbound_endpoints : format("%s-%s", endpoint.name, "outbe") => endpoint }
  # dns_forwarding_rulesets = { for ruleset in var.dns_forwarding_rulesets : ruleset.name => ruleset }
  # forwarding_rules        = { for rule in local.forwarding_rules_flattened : rule.name => rule }

  # endpoints = merge(local.inbound_endpoints, local.outbound_endpoints)


}
