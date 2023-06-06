variable "depends_on_resources" {
  default = []
}

resource "null_resource" "depends_on_resources" {
  triggers = {
    depends_on_resources = "${join("", var.depends_on_resources)}"
  }
}