resource "local_file" "private_key" {
  sensitive_content = tls_private_key.key.private_key_pem
  filename          = format("%s/%s/%s", abspath(path.root), ".ssh", "ssh-key.pem")
  file_permission   = "0600"
}

resource "local_file" "ansible_inventory" {
  filename = format("%s/%s/%s", abspath(path.root), "inventory", "inventory.yaml")
  file_permission   = "0600"
  content = <<EOF
ubuntu_server:
  hosts:
    ansible_host: ${aws_instance.ubuntu_web_server.public_ip} 
  vars:
    ansible_ssh_user: ubuntu
    ansible_ssh_private_key_file: ${local_file.private_key.filename}

postgres_database:
  hosts:
    db_host: ${aws_db_instance.GeoCitizenDB.endpoint}
  vars:
    db_user: ${aws_db_instance.GeoCitizenDB.username}
    db_password: ${aws_db_instance.GeoCitizenDB.password}
    db_name: ${aws_db_instance.GeoCitizenDB.db_name}
EOF
}

resource "local_file" "credentials" {
  filename = format("%s/%s/%s", abspath(path.root), "details", "credentials")
  file_permission   = "0600"
  content = <<EOF
ubuntu_host="${aws_instance.ubuntu_web_server.public_ip}"
db_host="${aws_db_instance.GeoCitizenDB.endpoint}"
EOF
}
