#!/bin/bash -xv

myIp=$(ip address show dev eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
myIpPre=$(echo $myIp | cut -d'.' -f1-3)
myIpPost=$(echo $myIp | cut -d'.' -f4)
ipUp=$((myIpPost + 1))
ipUp=$myIpPre.$ipUp
ipDown=$((myIpPost - 1))
ipDown=$myIpPre.$ipDown

limit=5
i=0
st2=

while true; do
	ping -c1 $ipDown
	if [ $? -eq 0 ]; then
		st2=$ipDown
		break
	fi
	ping -c1 $ipUp
        if [ $? -eq 0 ]; then
                st2=$ipUp
                break
        fi
	i=`expr $i + 1`
	[ $i -eq $limit ] && break
done

[ -z $st2 ] && st2='<ENTER HIRE THE APACHE IP>'

apt update
apt install -y nginx
cat > /etc/nginx/nginx.conf <<EOF
events { }
http {
	upstream beckend {
		server $st2:80;
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

