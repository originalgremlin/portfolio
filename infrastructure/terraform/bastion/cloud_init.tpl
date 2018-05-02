#cloud-config

# Packages
apt_reboot_if_required: false
apt_update: false
apt_upgrade: false

# SSH
disable_root: true

# System
locale: en_US.UTF-8
manage_etc_hosts: true
preserve_hostname: false
timezone: UTC

runcmd:
  - systemctl start hostname
  - systemctl enable mnt-efs.mount bastion_ssh
  - systemctl restart mnt-efs.mount bastion_ssh sshd

ssh_authorized_keys:
    - ssh-rsa EXAMPLE barry@example
