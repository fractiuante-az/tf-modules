resource "azurerm_eventhub" "this" {
  name                = "iot-eh-${var.identifier}"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_eventhub_namespace.this.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "this" {
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = azurerm_eventhub.this.name
  name                = "acctest"
  send                = true
}

module "sa_iot_hub" {
  source              = "../storage-account"
  resource_group_name = var.resource_group_name
  location            = var.location
  identifier          = "${var.identifier}iot"
  containers          = ["iot"]
}

resource "azurerm_eventhub_namespace" "this" {
  name                = "iot-ehns-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_iothub" "iot_hub" {
  name                = "iot-hub-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint {
    type                       = "AzureIotHub.StorageContainer"
    connection_string          = module.sa_iot_hub.primary_blob_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = module.sa_iot_hub.containers["iot"].name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
  }

  endpoint {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.this.primary_connection_string
    name              = "export2"
  }

  route {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
  }

  route {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
  }

  enrichment {
    key            = "tenant"
    value          = "$twin.tags.Tenant"
    endpoint_names = ["export", "export2"]
  }

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  tags = {
    purpose = "testing"
  }
}


#Create IoT Hub Access Policy
resource "azurerm_iothub_shared_access_policy" "hub_access_policy" {
  name                = "iot-access-policy-${var.identifier}"
  resource_group_name = var.resource_group_name
  iothub_name         = azurerm_iothub.iot_hub.name

  registry_read   = true
  registry_write  = true
  service_connect = true
}

# Create IoT Hub Device Provisioning Service
resource "azurerm_iothub_dps" "dps" {
  name                = "iot-dps-${var.identifier}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_policy   = "Hashed"

  sku {
    name     = "S1"
    capacity = 1
  }

  linked_hub {
    connection_string       = azurerm_iothub_shared_access_policy.hub_access_policy.primary_connection_string
    location                = var.location
    allocation_weight       = 150
    apply_allocation_policy = true
  }
}

resource "azurerm_iothub_consumer_group" "main" {
  name                   = "iot-cg-${var.identifier}"
  iothub_name            = azurerm_iothub.iot_hub.name
  eventhub_endpoint_name = "events"
  resource_group_name    = var.resource_group_name
}

# DEVICES -------------------------------
# You require additional permission to view IoT devices. The IoT Data Reader role or equivalent permission provides necessary permissions. If you have recently updated your permissions, please allow several minutes for changes to apply. Learn more
#  TODO: Add IoT Data Reader role

# Edge DEVICES -------------------------------
# You require additional permission to view IoT Edge devices. The IoT Data Reader role or equivalent permission provides necessary permissions. If you have recently updated your permissions, please allow several minutes for changes to apply. Learn more
#  TODO: Add IoT Data Reader role