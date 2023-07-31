resource "random_id" "id" {
  byte_length = 8
  keepers = {
    timestamp = "${timestamp()}" # force change on every execution
  }
}


locals {
  zip_path = var.force_update ? "init.${resource.random_id.id.dec}.linux-app.zip" : "init.linux-app.zip"
}

data "archive_file" "linux_app_file_zip" {
  type        = "zip"
  source_dir  = var.source_dir_path
  output_path = "init.linux-app.zip" #local.zip_path
}
