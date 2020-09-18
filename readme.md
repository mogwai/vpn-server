# VPN Server
This is an ansible scirpt to setup a vpn server on a remote machine. Mainly for the purpose of allowing access to a machine that doesn't have a public IP address.

**Only tested on Ubuntu**

There is a terraform file `open-vpn.tf` to create a server if you want.

## Instructions

1. Make sure that you have ssh access to a remote machine (Digital Ocean Droplet for example)
2. Install python on the remote server
3. `git clone git@github.com:mogwai/vpn-server`
4. `sudo apt install ansible openvpn` 
5. Edit the `dev` file to include your remote server's ip address
6. In the `vpnserver/files/base.conf`, add your server's ip address after `remote IP_ADDRESS` 
7. ansible-playbook site.yml
8. Connect to your vpn-server with sudo openvpn --config client1.ovpn

