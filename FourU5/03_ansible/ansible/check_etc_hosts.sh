#!/bin/bash

NODE_IPS=(
    "10.0.2.11"
    "10.0.3.11"
    "10.0.2.12"
    "10.0.3.12"
    "10.0.2.13"
    "10.0.3.13"
    "10.0.4.11"
)

# SSH 사용자
USER="ubuntu"

# SSH 키 경로
SSH_KEY="/home/ubuntu/ansible/foryou_key.pem"

# 각 노드의 /etc/hosts 파일 내용 확인
for IP in "${NODE_IPS[@]}"; do
    echo "Connecting to $IP..."
    ssh -i "$SSH_KEY" "$USER@$IP" "cat /etc/hosts"
    echo "-------------------------------------"
done

# 실행방법
# chmod +x check_hosts.sh
# ./check_hosts.sh