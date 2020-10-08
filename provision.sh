#!/bin/bash

###
## Provision the web application
###

sudo su

yum update -y

yum install util-linux-user -y

yum groupinstall "Development Tools" -y

# Install Nginx
yum install nginx -y
amazon-linux-extras install nginx1 -y

# Create a new user to run the web application as a service and disable the login shell
useradd webapp
chsh -s /sbin/nologin webapp

# Install Git
yum install git -y

yum install python3-pip -y

pip3 install pipenv

yum install @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
sqlite-devel openssl-devel xz xz-devel libffi-devel findutils -y

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc 
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc

echo 'export PATH="$PATH:/usr/local/bin"' >> /home/webapp/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/webapp/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/webapp/.bashrc

# pyenv install 3.8.5

# Downloads application repository
git clone https://github.com/garibaldiviolin/pythonapi.git /home/webapp/pythonapi

echo "DATABASE_HOST=${database_endpoint}" | sed -e 's/\(:5432\)*$//g' > /home/webapp/pythonapi/.env
echo "DATABASE_USER=${database_user}" >> /home/webapp/pythonapi/.env
echo "DATABASE_PASSWORD=${database_password}" >> /home/webapp/pythonapi/.env
echo "ALLOWED_HOSTS=${alb_endpoint}" >> /home/webapp/pythonapi/.env

cd /home/webapp/pythonapi

# psycopg2 dependencies
yum install python-devel postgresql-devel -y

pipenv install --dev

pipenv run python src/manage.py migrate

# Write a Nginx site configuration file to redirect port 80 to 8080
cat << EOF > /etc/nginx/conf.d/webapp.conf
server {
    listen 80 default_server;

    location / {
        proxy_set_header    X-Real-IP \$remote_addr;
        proxy_set_header    Host \$http_host;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass          http://127.0.0.1:8080;
    }
}
EOF

# Rewrite the default Nginx configuration file to disable the default site
cat << EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /var/run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
    
    index   index.html index.htm;
}
EOF

# Start the Nginx and Webapp services
service nginx start

pipenv run gunicorn --chdir src/ pythonapi.wsgi --workers=2 -b 127.0.0.1:8080 &
