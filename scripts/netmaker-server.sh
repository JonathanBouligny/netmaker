#!/bin/sh
set -e

mkdir -p /etc/netmaker/config/environments
wget -O /etc/netmaker/netmaker https://github.com/gravitl/netmaker/releases/download/latest/netmaker
chmod +x /etc/netmaker/netmaker


cat >/etc/netmaker/config/environments/dev.yaml<<EOL
server:
  host:
  apiport: "8081"
  grpcport: "50051"
  masterkey: "secretkey"
  allowedorigin: "*"
  restbackend: true            
  agentbackend: true
  defaultnetname: "default"
  defaultnetrange: "10.10.10.0/24"
  createdefault: true
mongoconn:
  user: "mongoadmin"
  pass: "mongopass"
  host: "localhost"
  port: "27017"
  opts: '/?authSource=admin'
EOL

cat >/etc/systemd/system/netmaker.service<<EOL
[Unit]
Description=Netmaker Server
After=network.target

[Service]
Type=simple
Restart=on-failure

WorkingDirectory=/etc/netmaker
ExecStart=/etc/netmaker/netmaker

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl start netmaker.service
