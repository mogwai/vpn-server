name=$1
start_dir=$(pwd)

if [ -z "$name" ]
then
	exit
fi

cd ~/vpn_server/easyrsa/
./easyrsa gen-req $name nopass
cp pki/private/$name.key ~/client-configs/keys/
cd ~/ca_server/easyrsa/
./easyrsa import-req ~/vpn_server/easyrsa/pki/reqs/$name.req $name
./easyrsa sign-req client $name
cp ~/ca_server/easyrsa/pki/issued/$name.crt ~/client-configs/keys/
cd ~/client-configs/
./make_config.sh $name

cd $start_dir

