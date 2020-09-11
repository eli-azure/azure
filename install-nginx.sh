#!/bin/bash -xv
apt update
apt install -y nginx
cat > /etc/nginx/nginx.conf <<EOF
events { }
http {
	upstream beckend {
		server 10.0.0.4:80;
		}
	server {
		listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/eli.crt;
        ssl_certificate_key /etc/nginx/ssl/eli.key;
		location / {
			proxy_pass http://beckend/;
		}
	}
}
EOF
#systemctl restart nginx
