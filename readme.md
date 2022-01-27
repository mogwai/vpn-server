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


## Forwarding traffic

1. Uncommment the `push redirect-gateway def` in `/etc/openvpn/sever.conf`
2. Restart the server
3. Determine egress network interface `eth0`
4. iptables on the server need to be setup

```
# Masquerade outgoing traffic
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# Allow return traffic
iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Forward everything
iptables -A FORWARD -j ACCEPT
```

install openresolv

https://blog.syddel.uk/?p=253



## Delete a client

delete ca_server/certs_by_serial
delete line from ca_server/easyrsa/pki/index.txt

