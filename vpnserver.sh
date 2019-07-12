#!/bin/bash

ip=$1

rc() {
    ssh ubuntu@$ip $1
}

rc 'sudo apt update'
rc 'sudo apt install openvpn'
rc 'wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz'
rc 'tar xvf ~EasyRSA-3.0.4.tgz'
scp 'vars ubuntu@$ip:/home/ubuntu/EasyRSA-3.0.4/'
rc '.~/EasyRSA-3.0.4/easyrsa init-pki'
rc .~/EasyRSA-3.0.4/easyrsa build-ca nopass
rc cp EasyRSA-3.0.4 VPNRSA
rc .~/VPNRSA/easyrsa init-pki
