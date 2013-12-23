#!/bin/bash
#node.js + mongodb driver
ab -n 500 -c 5 http://10.31.219.246:3000/getfile/1k/ > node_1k.log
ab -n 500 -c 5 http://10.31.219.246:3000/getfile/100k/ > node_100k.log
ab -n 500 -c 5 http://10.31.219.246:3000/getfile/1m/ > node_1m.log