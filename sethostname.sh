sudo hostname $1
sudo hostnamectl --static set-hostname $1
sudo sed -e 's/preserve_hostname^C/preserve_hostname true/' /etc/cloud/cloud.cfg > /dev/null