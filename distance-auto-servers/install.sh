# Install node 14.x for Ubuntu
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Update
sh $(dirname "$0")/update.sh