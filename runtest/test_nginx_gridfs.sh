#!/bin/bash
#nginx_gridfs
ab -n 500 -c 5 http://10.31.219.246:80/gridfs/1k > ngxgridfs_1k.log
ab -n 500 -c 5 http://10.31.219.246:80/gridfs/100k > ngxgridfs_100k.log
ab -n 500 -c 5 http://10.31.219.246:80/gridfs/1m > ngxgridfs_1m.log