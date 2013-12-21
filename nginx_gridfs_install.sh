#!/bin/bash
apt-get udpate
apt-get install git gcc make libpcre3-dev libz-dev

cd /home/ubuntu
wget http://nginx.org/download/nginx-1.4.4.tar.gz
tar -xvf nginx-1.4.4.tar.gz


git clone https://github.com/mdirolf/nginx-gridfs.git
cd nginx-gridfs
git chekcout v0.8
git submodule init
git submodule update
cd ..


cd /home/ubuntu/nginx-1.4.4
./configure --add-module=/home/ubuntu/nginx-gridfs/ --with-cc-opt=-Wno-error
make
make install

