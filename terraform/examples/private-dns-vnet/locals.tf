locals {
  identifier          = "private-dns-example"
  private_domain_name = "sample-dns.de"

  # inbound_endpoints       = { for endpoint in var.inbound_endpoints : format("%s-%s", endpoint.name, "inbe") => endpoint }
  # outbound_endpoints      = { for endpoint in var.outbound_endpoints : format("%s-%s", endpoint.name, "outbe") => endpoint }
  # dns_forwarding_rulesets = { for ruleset in var.dns_forwarding_rulesets : ruleset.name => ruleset }
  # forwarding_rules        = { for rule in local.forwarding_rules_flattened : rule.name => rule }

  # endpoints = merge(local.inbound_endpoints, local.outbound_endpoints)


}
