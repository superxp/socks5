#! /bin/bash

# 请自行安装jdk8

sudo su
mkdir /opt/socks5
cd /opt/socks5
wget -O client.jar https://github.com/arloor/socks5/releases/download/latest/client-3.0-jar-with-dependencies.jar

mkdir /etc/socks5
cat > /etc/socks5/client.json <<EOF
{
  "ClientPort": 6666,
  "SpeedLimitKB": 640,
  "Use": 0,
  "Servers": [
    {
      "ProxyAddr": "socks5",
      "ProxyPort": 80,
      "UserName": "a",
      "Password": "b"
    },
    {
      "ProxyAddr": "localhost",
      "ProxyPort": 80,
      "UserName": "a",
      "Password": "b"
    }
  ],
  "User": "this",
  "Pass": "socks5",
  "Auth":true
}
EOF

#创建service
cat > /lib/systemd/system/ss5-local.service <<EOF
[Unit]
Description=socks5代理-客户端ARLOOR
After=network-online.target
Wants=network-online.target

[Service]
Restart=always
WorkingDirectory=/opt/socks5
ExecStart=/usr/bin/java -jar /opt/socks5/client.jar -c /etc/socks5/client.json
LimitNOFILE=100000
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable ss5-local
# vim /etc/socks5/client.json
# service ss5-local start