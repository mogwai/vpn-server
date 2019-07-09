#!/bin/sh

# terraform apply -auto-approve
# ip=$(terraform output ip)

ip=18.200.107.240

rc () {
    ssh ubuntu@$ip $1
}

rc 'sudo apt update'