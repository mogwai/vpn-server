#!/bin/sh

terraform apply -auto-approve
ip=$(terraform output ip)

rc() {
    ssh ubuntu@$ip $1
}

rc 'sudo apt update'
