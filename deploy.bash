#!/bin/bash
EC2_USER=ec2-user

#remove host file and any existing keys
rm hosts
rm minecraft_key.pem
rm minecraft_key.pub

# make key pair
ssh-keygen -t rsa -b 2048 -m PEM -f minecraft_key -N ""
mv minecraft_key minecraft_key.pem
chmod 600 minecraft_key.pem

# install terraform https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update

sudo apt-get install terraform

# install ansible https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# run terraform
terraform init
terraform apply -auto-approve

# get ec2 public ip
EC2_IP=$(terraform output -raw instance_public_ip)

# add ansible host
echo "[server]" > hosts
echo "$EC2_IP ansible_user=ec2-user ansible_ssh_private_key_file=minecraft_key.pem" >> hosts

echo "Sleeping for 2 minutes to allow the instance to initialize..."
sleep 2m

# run ansible
sudo ansible-playbook -i hosts minecraft-setup.yml

# output IP
echo "Minecraft server IP: $EC2_IP"