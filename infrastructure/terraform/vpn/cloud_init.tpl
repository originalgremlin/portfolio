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
  - systemctl start hostname.service
  - systemctl enable hostname openvpn@server
  - systemctl restart hostname openvpn@server
