resource "vultr_instance" "my_instance" {
    count = length(var.server_count)
    plan = "vc2-1c-1gb"
    region = "sea"
    os_id = 167
}

resource "vultr_reserved_ip" "my_reserved_ip" {
    count = length(var.count_dop_ip)
    prefix  = "my-reserved-ip"
    region = "sea"
    ip_type = "v4"
    instance_id = vultr_instance.my_instance[count.index%3].id
}

resource "vultr_dns_domain" "my_domain" {
    count = length(var.count_dop_ip)
    domain = element(var.count_dop_ip, count.index)
    ip = element(vultr_reserved_ip.my_reserved_ip, count.index)
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

