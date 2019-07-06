#!/bin/sh

terraform apply -auto-approve
ip=$(terraform output ip)
echo $ip
