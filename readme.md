# Setup a VPN Server 
Starting offline docker container: 
```
cd docker
echo ansible | ssh-keygen
docker build -t vpn_server:latest .
docker run -d -p 2222:22 --name vpn_server vpn_server
```

### All steps

CA Server & VPN Server

sudo apt update
sudo apt install openvpn
wget -P ~/ https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz
cd ~
tar xvf EasyRSA-3.0.4.tgz
cd ~/EasyRSA-3.0.4/

CA Server
cp vars.example vars
nano vars
./easyrsa init-pki
./easyrsa build-ca nopass

VPN Server

./easyrsa init-pki
./easyrsa gen-req server nopass
sudo cp ~/EasyRSA-3.0.4/pki/private/server.key /etc/openvpn/
scp ~/EasyRSA-3.0.4/pki/reqs/server.req sammy@your_C A_ip:/tmp

CA Server
./easyrsa import-req /tmp/server.req server
./easyrsa sign-req server server
scp pki/issued/server.crt sammy@your_server_ip:/tmp
scp pki/ca.crt sammy@your_server_ip:/tmp

VPN Server
sudo cp /tmp/{server.crt,ca.crt} /etc/openvpn/
./easyrsa gen-dh
openvpn --genkey --secret ta.key
sudo cp ~/EasyRSA-3.0.4/ta.key /etc/openvpn/
sudo cp ~/EasyRSA-3.0.4/pki/dh.pem /etc/openvpn/

mkdir -p ~/client-configs/keys
cd ~/EasyRSA-3.0.4/
./easyrsa gen-req client1 nopass
cp pki/private/client1.key ~/client-configs/keys/
scp pki/reqs/client1.req sammy@your_CA_ip:/tmp

CA Server
./easyrsa import-req /tmp/client1.req client1
./easyrsa sign-req client client1
scp pki/issued/client1.crt sammy@your_server_ip:/tmp

VPN Server
cp /tmp/client1.crt ~/client-configs/keys/
cp ~/EasyRSA-3.0.4/ta.key ~/client-configs/keys/
sudo cp /etc/openvpn/ca.crt ~/client-configs/keys/

sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
sudo gzip -d /etc/openvpn/server.conf.gz
sudo nano /etc/openvpn/server.conf

sudo ufw disable
sudo nano /etc/default/ufw
DEFAULT_FORWARD_POLICY="ACCEPT"

sudo systemctl start openvpn@serve
sudo systemctl status openvpn@server
sudo systemctl enable openvpn@server

mkdir -p ~/client-configs/files
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf ~/client-configs/base.conf
nano ~/client-configs/base.conf 