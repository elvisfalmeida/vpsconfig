#!/bin/bash

# Atualiza o sistema
apt update && apt upgrade -y

# Altera o timezone
timedatectl set-timezone America/Sao_Paulo
timezone="America/Sao_Paulo"

# Inicializa variáveis para rastrear mudanças
hostname_changed=false
ssh_port_changed=false

# Pergunta se o usuário deseja alterar o hostname
read -p "Deseja alterar o hostname? (s/n): " change_hostname
if [[ $change_hostname == "s" || $change_hostname == "S" ]]; then
  read -p "Digite o novo hostname: " new_hostname
  hostnamectl set-hostname $new_hostname
  hostname_changed=true
  echo "Hostname definido como: $new_hostname"
else
  new_hostname=$(hostname)
  echo "Hostname não alterado."
fi

# Pergunta se o usuário deseja alterar a porta SSH
read -p "Deseja alterar a porta SSH? (s/n): " change_ssh_port
if [[ $change_ssh_port == "s" || $change_ssh_port == "S" ]]; then
  read -p "Digite a nova porta SSH: " new_ssh_port
  sed -i "s/#Port 22/Port $new_ssh_port/" /etc/ssh/sshd_config
  systemctl restart sshd
  ssh_port_changed=true
  echo "Porta SSH alterada para: $new_ssh_port"
else
  new_ssh_port="22"
  echo "Porta SSH não alterada."
fi

echo "Configurações básicas aplicadas com sucesso!"

# Resumo das alterações
echo "Resumo das alterações:"
echo "Timezone: $timezone"
if $hostname_changed; then
  echo "Hostname alterado para: $new_hostname"
else
  echo "Hostname não alterado."
fi

if $ssh_port_changed; then
  echo "Porta SSH alterada para: $new_ssh_port"
else
  echo "Porta SSH não alterada."
fi
