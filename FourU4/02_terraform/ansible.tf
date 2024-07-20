# aws 생성 ip로 inventory file 생성
resource "local_file" "ansible_inventory" {
    content = templatefile("${path.root}/../03_ansible/ansible/inventory.tftpl",
        {
            masters_dns = aws_instance.masters.*.private_dns,
            masters_ip  = aws_instance.masters.*.private_ip,
            masters_id  = aws_instance.masters.*.id,
            workers_dns = aws_instance.workers.*.private_dns,
            workers_ip  = aws_instance.workers.*.private_ip,
            workers_id  = aws_instance.workers.*.id
        }    
    )
    filename = "${path.root}/../03_ansible/ansible/inventory"
}

# Ansible 디렉토리에 키 복사
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

# inventory 프로비저닝
# resource "null_resource" "provisioner" {
#   depends_on    = [
#     local_file.ansible_inventory,
#     time_sleep.wait_for_bastion_init,
#     aws_instance.bastion
#     ]

#   triggers = {
#     "always_run" = timestamp()
#   }

#   provisioner "file" {
#     source  = "${path.root}/../03_ansible/ansible/inventory"
#     destination = "/home/ubuntu/inventory"

#     connection {
#       type          = "ssh"
#       host          = aws_instance.bastion.public_ip
#       user          = var.ssh_user
#       private_key   =  tls_private_key.ssh.private_key_pem
#       agent         = false
#     }
#   }
# }


# ansible 관련 파일 프로비저닝
resource "local_file" "ansible_vars_file" {
    content = <<-DOC

        master_lb: ${aws_lb.nlb.dns_name}
        DOC
    filename = "${path.root}/../03_ansible/ansible/ansible_vars_file.yml"
}

resource "null_resource" "copy_ansible_playbooks" {
  depends_on    = [
    //null_resource.provisioner,
    time_sleep.wait_for_bastion_init,
    aws_instance.bastion,
    local_file.ansible_vars_file
    ]

  triggers = {
    "always_run" = timestamp()
  }

  provisioner "file" {
      source = "${path.root}/../03_ansible/ansible"
      destination = "/home/ubuntu/ansible/"

      connection {
        type        = "ssh"
        host        = aws_instance.bastion.public_ip
        user        = var.ssh_user
        private_key = tls_private_key.ssh.private_key_pem
        agent         = false
      }
  }
}

# bastion -> master 파일 전달 (필요없음)
# resource "null_resource" "copy_ansible_to_master" {
#   depends_on = [
#     null_resource.copy_ansible_playbooks,
#     aws_instance.masters,
#     aws_instance.bastion
#   ]

#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "echo 'Master public IP: ${element(aws_instance.masters.*.public_ip, 0)}'"
#   }

#   provisioner "file" {
#     source      = "${path.root}/../03_ansible/ansible"
#     destination = "/home/ubuntu/ansible"

#     connection {
#       type               = "ssh"
#       host               = element(aws_instance.masters.*.private_ip, 0)
#       user               = var.ssh_user
#       private_key        = tls_private_key.ssh.private_key_pem
#       agent              = false
#       bastion_host       = aws_instance.bastion.public_ip
#       bastion_user       = var.ssh_user
#       bastion_private_key = tls_private_key.ssh.private_key_pem
#     }
#   }
# }


# ansible 원격 실행(에러)
# resource "null_resource" "run_ansible" {
#  depends_on = [
#     null_resource.provisioner,
#     null_resource.copy_ansible_playbooks,
#     null_resource.copy_ansible_to_master,
#     aws_instance.masters,
#     aws_instance.workers,
#     module.vpc,
#     aws_instance.bastion,
#     time_sleep.wait_for_bastion_init
#   ]

#   triggers = {
#     always_run = timestamp()
#   }

#   connection {
#     type                   = "ssh"
#     host                   = aws_instance.bastion.public_ip
#     user                   = var.ssh_user
#     private_key            = tls_private_key.ssh.private_key_pem
#     agent                  = false
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sleep 60 && ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@${element(aws_instance.masters.*.private_ip, 0)} 'ansible-playbook -i /home/ubuntu/ansible /home/ubuntu/ansible/galaxy.yml",
#       "sleep 60 && ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@${element(aws_instance.masters.*.private_ip, 0)} 'ansible-playbook -i /home/ubuntu/ansible /home/ubuntu/ansible/playbook.yml ",
#       "sleep 60 && ssh -o StrictHostKeyChecking=no -i /home/ubuntu/.ssh/id_rsa ubuntu@${element(aws_instance.masters.*.private_ip, 0)} 'ansible-playbook -i /home/ubuntu/ansible /home/ubuntu/ansible/helm_prometheus.yml'"
#     ]
#   }
# }