
## How to connect your ubuntu machine to be a jenkins build slave

Remove all alternate versions of java*
sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*

Add the new ppa:
sudo add-apt-repository ppa:webupd8team/java

Install the new jre
sudo apt-get update 
sudo apt-get install oracle-java6-installer

Then, reboot

After reboot, you will need to alter the security settings to allow self signed certs for out jenkins server.

run javaws from the cli. 
Click on the security tab
In the Exception site list, click add.
Add https://jenkins.michaelgregg.com:8080

head to https://jenkins.michaelgregg.com:8080/computer/<your node name>/

After that, you can either click on the "Launch" button. Click alll if the crazy dialogs to allow the unsigned cert.

## Installing Jenkins on Ubuntu

# Install base system
# https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo aptitude update
sudo aptitude upgrade
sudo aptitude install jenkins

# Create self signed ssl keys
# Generated from https://devcenter.heroku.com/articles/ssl-certificate-self
sudo mkdir /etc/ssl/jenkins
cd /etc/ssl/jenkins
sudo openssl genrsa -des3 -passout pass:<password> -out jenkins.pass.key 2048
sudo openssl rsa -passin pass:<password> -in jenkins.pass.key -out server.key
sudo rm jenkins.pass.key
sudo openssl req -new -key server.key -out server.csr
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# Because Jenkins and java have all sorts of reoccuring bugs, we use nigix to make the jenkins server ssl.

Edit /etc/default/jenkins
Alter the JENKINS_ARGS file, add "--httpListenAddress=127.0.0.1" to make jenkins listen only on localhost.
sudo aptitude install nginx

Edit /etc/nginx/sites-enabled/default
comment out the entire first server entry

Add
server {

    listen 204.11.224.243:8080;
    server_name jenkins.michaelgregg.com;

    ssl_certificate           /etc/ssl/jenkins/server.crt;
    ssl_certificate_key       /etc/ssl/jenkins/server.key;

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;

    access_log            /var/log/nginx/jenkins.access.log;

    location / {

      proxy_set_header        Host $host;
      proxy_set_header        X-Real-IP $remote_addr;
      proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto $scheme;

      # Fix the “It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://localhost:8080;
      proxy_read_timeout  90;

      proxy_redirect      http://localhost:8080 https://jenkins.michaelgregg.com:8080;
    }
  }


