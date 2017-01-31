apt-get update
apt-get install debconf-utils -y
echo "chef  chef/chef_server_url    string  0.0.0.0:7777"| debconf-set-selections
apt-get install chef -y
mkdir -p /home/vagrant/chef-repo
chef-client --local-mode /vagrant/portfolio/install.rb
