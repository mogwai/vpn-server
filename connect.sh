#!/bin/sh

terraform apply --auto-approve
ip=$(terraform output ip)
echo ip > dev
ansible-playbook site.yml
sudo openvpn --config client1.ovpn
