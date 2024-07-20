#!/bin/bash
echo 'starting ansible playbooks...'

# Sleep for 60 seconds to allow for any initial setup
sleep 60

# Run the Ansible playbooks
ansible-playbook -i /home/ubuntu/inventory /home/ubuntu/ansible/playbook.yml -vvv | tee /home/ubuntu/ansible/playbook.log
sleep 60
ansible-playbook -i /home/ubuntu/inventory /home/ubuntu/ansible/galaxy.yml -vvv | tee /home/ubuntu/ansible/galaxy.log
sleep 60
ansible-playbook -i /home/ubuntu/inventory /home/ubuntu/ansible/helm_prometheus.yml -vvv | tee /home/ubuntu/ansible/helm_prometheus.log