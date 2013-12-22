#!/bin/bash
#flask+pymongo
ab -n 500 -c 5 http://10.31.219.246:5000/getfile/1k/ > flask_1k.log
ab -n 500 -c 5 http://10.31.219.246:5000/getfile/100k/ > flask_100k.log
ab -n 500 -c 5 http://10.31.219.246:5000/getfile/1m/ > flask_1m.log