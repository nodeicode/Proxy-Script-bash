#!/bin/bash
//xdotool key ctrl+shift+t
//google-chrome-stable
read -p "Enter ip port: " P S
echo $P
echo $S
PROX=$P
PRT=$S

gsettings set org.gnome.system.proxy mode manual
gsettings set org.gnome.system.proxy.http host "$PROX"
gsettings set org.gnome.system.proxy.http port "$PRT"
gsettings set org.gnome.system.proxy.https host "$PROX"
gsettings set org.gnome.system.proxy.https port "$PRT"

sudo touch /etc/apt/apt.conf.d/proxy.conf

sudo sed -i.bak '/http[s]::Proxy/Id' /etc/apt/apt.conf.d/proxy.conf
sudo tee -a /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "http://$PROX:$PRT/";
Acquire::https::Proxy "http://$PROX:$PRT/";
EOF

//TODO delete the garbage entries in both conf files

sudo sed -i.bak '/http[s]_proxy/Id' /etc/environment
sudo tee -a /etc/environment <<EOF
http_proxy="http://$PROX:$PRT/"
https_proxy="http://$PROX:$PRT/"
EOF

export http_proxy=$(pam_getenv http_proxy)
