
# module "sa_app_files_storage" {
#   source              = "../storage-account"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   identifier          = "${var.identifier}laf"
#   containers          = ["app-zip"]
# }

# data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
#   connection_string = module.sa_app_files_storage.primary_connection_string
#   container_name    = "app-zip"

#   start  = "2023-01-01T00:00:00Z"
#   expiry = "2024-01-01T00:00:00Z"

#   permissions {
#     read   = true
#     add    = false
#     create = false
#     write  = false
#     delete = false
#     list   = false
#   }
# }

# resource "azurerm_storage_blob" "storage_blob" {
#   name                   = "${filesha256(data.archive_file.linux_app_file_zip.output_path)}.zip"
#   storage_account_name   = module.sa_app_files_storage.storage_account_name
#   storage_container_name = "app-zip"

#   type   = "Block"
#   source = data.archive_file.linux_app_file_zip.output_path
# }
