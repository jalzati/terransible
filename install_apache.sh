#! /bin/bash
sudo touch /tmp/foo.txt
sudo echo "Jorge was here!!!" > /tmp/foo.txt
sudo yum -y install httpd
sudo systemctl enable httpd
sudo systemctl start httpd.service
sudo echo "<center><h1>Deployed via Terraform</h1><center><hr><center><i>Powered by Terraform</i></center>" | sudo tee /var/www/html/index.html