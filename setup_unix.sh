#!/bin/bash

# Atualiza o sistema
apt update && apt upgrade -y

# Altera o timezone
timedatectl set-timezone America/Sao_Paulo

# Solicita o hostname ao usuário
read -p "Digite o novo hostname: " new_hostname

# Altera o hostname
hostnamectl set-hostname $new_hostname

# Altera a porta SSH para 9022
sed -i 's/#Port 22/Port 9022/' /etc/ssh/sshd_config
systemctl restart sshd

echo "Configurações básicas aplicadas com sucesso!"
echo "Hostname definido como: $new_hostname"
