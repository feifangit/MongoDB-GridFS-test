#!/bin/bash
#nginx 
ab -n 500 -c 5 http://10.31.219.246:80/files/1k > nginx_1k.log
ab -n 500 -c 5 http://10.31.219.246:80/files/100k > nginx_100k.log
ab -n 500 -c 5 http://10.31.219.246:80/files/1m > nginx_1m.log
