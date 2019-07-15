#! /bin/bash

docker kill vpn_server
docker rm vpn_server
cd docker
echo ansible | ssh-keygen
docker build -t vpn_server:latest .
docker run -t -d -p 2222:22 --name vpn_server vpn_server
