# [local] aws ec2 ip로 inventory file 생성
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tftpl",
    {
      bastion_dns  = aws_instance.bastion.private_dns,
      bastion_ip   = aws_instance.bastion.private_ip,
      bastion_id   = aws_instance.bastion.id,
      masters_dns  = aws_instance.masters[*].private_dns,
      masters_ip   = aws_instance.masters[*].private_ip,
      masters_id   = aws_instance.masters[*].id,
      workers_dns  = aws_instance.workers[*].private_dns,
      workers_ip   = aws_instance.workers[*].private_ip,
      workers_id   = aws_instance.workers[*].id,
      database_dns = aws_instance.database.private_dns,
      database_ip  = aws_instance.database.private_ip,
      database_id  = aws_instance.database.id,
    }
  )
  filename = "${path.root}/../03_ansible/ansible/inventory"
}

# [local] Ansible directory에 키 복사
resource "local_file" "ansible_k8_ssh_key" {
  filename        = "${path.root}/../03_ansible/ansible/${var.name}_key.pem"
  file_permission = "600"
  content         = tls_private_key.ssh.private_key_pem
}

resource "time_sleep" "wait_for_bastion_init" {
  depends_on = [aws_instance.bastion]

  create_duration = "120s"

  triggers = {
    "always_run" = timestamp()
  }
}

# [local] Ansible directory에 nlb ip, database ip 변수 복사
resource "local_file" "ansible_vars_file" {
  content  = <<-DOC
        master_lb: ${aws_lb.nlb.dns_name}
        database: ${aws_instance.database.public_ip}
        DOC
  filename = "${path.root}/../03_ansible/ansible/ansible_vars_file.yml"
}

# [local->bastion] ansible 관련 파일 이동
resource "null_resource" "copy_ansible_playbooks" {
  depends_on = [
    time_sleep.wait_for_bastion_init,
    aws_instance.bastion,
    local_file.ansible_vars_file
  ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
    source      = "${path.root}/../03_ansible/ansible"
    destination = "/home/ubuntu/ansible/"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = var.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
      agent       = false
    }
  }
}


# [local->bastion] role 파일 이동
resource "null_resource" "copy_ansible_role" {
  depends_on = [
    null_resource.copy_ansible_playbooks
  ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
    source      = "${path.root}/../03_ansible/role"
    destination = "/home/ubuntu/ansible/role"

    connection {
      type        = "ssh"
      host        = aws_instance.bastion.public_ip
      user        = var.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
      agent       = false
    }
  }
}


resource "null_resource" "run_ansible" {
  depends_on = [
    null_resource.copy_ansible_role
  ]

  triggers = {
    always_run = timestamp()
  }

  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = var.ssh_user
    private_key = tls_private_key.ssh.private_key_pem
    agent       = false
  }

  provisioner "file" {
    source      = "run_ansible.sh"
    destination = "/home/ubuntu/run_ansible.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/run_ansible.sh",
      "/home/ubuntu/run_ansible.sh"
    ]
  }
}