
resource "ah_cloud_server" "server" {
  count = length(var.server_count)
  datacenter = "ams1"
  image = "centos-7-x64"
  plan = "start-xs"
}


resource "ah_ip" "additional_ip" {
  count = length(var.count_dop_ip)
  type = "public"
  datacenter = "ams1"

}


resource "ah_ip_assignment" "server_ip" {
  count = length(var.count_dop_ip)
  cloud_server_id = ah_cloud_server.server[count.index].id
  ip_address = ah_ip.additional_ip[count.index%3].id
}


resource "null_resource" "output" {
  provisioner "local-exec" {
    command = <<-EOT
      <% for idx, server in advancedhosting_server.server -%>
      echo "сервер${idx + 1}:"
      echo "  айпи сервера: ${server.ip_address}"
      echo "  пользователь: ${server.username}"
      echo "  пароль: ${server.password}"
      <% for i = 0; i < length(var.count_dop_ip); i++ -%>
      echo "  - доп айпи ${i + 1}:"
      <% for j = 0; j < 4; j++ -%>
      echo "    домен${j + 1}: ${advancedhosting_dns_record.domain[i * 4 + j].name}"
      <% endfor -%>
      <% endfor -%>
      <% endfor -%>
    EOT

    command = "echo './output.txt' > output.txt"
  }
}

