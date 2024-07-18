MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
  set -ex
  sudo yum update -y
  sudo amazon-linux-extras install ansible2 -y

  # Define the log file
  LOG_FILE=${var.log_file}

  # Redirect all output (stdout and stderr) to the log file
  exec >> "$LOG_FILE" 2>&1

  AWS_ACCESS_KEY_ID="${aws_access_key_id}"
  AWS_SECRET_ACCESS_KEY="${aws_secret_access_key}"
  AWS_REGION="${aws_region}"
  CLUSTER_NAME="${eks_cluster_ansible_name}"
  NODE_GROUP_INSTANCE_TYPE="${aws_eks_node_group_instance_types}"
  KUBERNETES_VERSION="${aws_eks_cluster_ansible_version}"

  sudo -u ec2-user /usr/bin/aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
  sudo -u ec2-user /usr/bin/aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
  sudo -u ec2-user /usr/bin/aws configure set  default.region $AWS_REGION
  echo "AWS CLI configured with your credentials."

  # Install kubectl
  if ! [ -x "$(command -v kubectl)" ]; then
      echo "Installing kubectl..."
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/bin/
      echo "kubectl installed."
  else
      echo "kubectl is already installed."
  fi

  # Fetch max pods
  curl -O https://raw.githubusercontent.com/awslabs/amazon-eks-ami/master/files/max-pods-calculator.sh
  chmod +x max-pods-calculator.sh

  # Fetch the cluster's certificate authority data
  CERTIFICATE_AUTHORITY=$(sudo -u ec2-user /usr/bin/aws eks describe-cluster --query "cluster.certificateAuthority.data" --output text --name $CLUSTER_NAME --region $AWS_REGION)

  # Define the cluster endpoint URL
  API_SERVER_ENDPOINT=$(sudo -u ec2-user /usr/bin/aws eks describe-cluster --region $AWS_REGION --name $CLUSTER_NAME --query "cluster.endpoint" --output text)

  # Fetch the cluster's CIDR
  SERVICE_CIDR=$(sudo -u ec2-user /usr/bin/aws eks describe-cluster --query "cluster.kubernetesNetworkConfig.serviceIpv4Cidr" --output text --name $CLUSTER_NAME --region $AWS_REGION | sed 's/\.0\/16//')

  CNI_VERSION=$(sudo -u ec2-user /usr/bin/aws eks describe-addon-versions --addon-name vpc-cni --kubernetes-version $KUBERNETES_VERSION --region $AWS_REGION | jq -r '.addons[] | select(.addonName == "vpc-cni") | .addonVersions[].addonVersion' | head -n 1 | sed 's/^v//')

  MAX_PODS=$(./max-pods-calculator.sh --instance-type $NODE_GROUP_INSTANCE_TYPE --cni-version $CNI_VERSION)

  # Join worker nodes to the eks cluster
  /etc/eks/bootstrap.sh eks-cluster $CLUSTER_NAME \
    --b64-cluster-ca $CERTIFICATE_AUTHORITY \
    --apiserver-endpoint $API_SERVER_ENDPOINT \
    --dns-cluster-ip $SERVICE_CIDR.10 \
    --kubelet-extra-args "--max-pods=$MAX_PODS" \
    --use-max-pods false

--==MYBOUNDARY==--