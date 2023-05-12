provider "ah" {}

module "Infrastructure" {
  source = "./ah"
  server_count = "{{cookiecutter.server_count}}"
  count_dop_ip = "${var.domain_list}"  
}