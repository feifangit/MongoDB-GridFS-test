## Purpose
[MongoDB GridFS](http://docs.mongodb.org/manual/core/gridfs/) comes with some natural advantages such as scalability(sharding) and HA(replica set). But as it stores file as ASCII string, there's no doubt a performance loss.

I'm just comparing performance on different deployment. Serve static files from Hard disk or from a Database blob system is your choice.


### Test items:
>
 1. file served by Nginx directly 
 2. file served by Nginx_gridFS + GridFS
 3. file served by Flask + pymongo + gevent + GridFS
 4. file served by Node.js + GridFS

### Files for downloading:
Run script [insert_file_gridfs.py](/insert_file_gridfs.py) from MongoDB server to insert 4 different size of file to database <strong>test1</strong>

pymongo is required
>
 - 1KB
 - 100KB
 - 1MB

### Test Environment
2 servers:
>
 - MongoDB+Application/Nginx 
 - tester(Apache ab/JMeter) 

hardware:
> 
 - Amazon EC2 [m1.medium](http://aws.amazon.com/ec2/instance-types/#selecting-instance-types)
 - Ubuntu 12.04 x64

## Configurations

### 1, Nginx
<pre>
location /files/ {
  alias /home/ubuntu/;
} 
</pre>

### 2, Nginx_GridFS
It's a Nginx plugin based on MongoDB C driver. [https://github.com/mdirolf/nginx-gridfs](https://github.com/mdirolf/nginx-gridfs)

#### Compile code & install
I made a quick [install script](/nginx_gridfs_install.sh) in this repo, run it with ``sudo``. After Nginx is ready, modify the configration file under /usr/local/nginx/conf/nginx.conf (if you didn't change the path). 

#### Configuration
<pre>
location /gridfs/{
   gridfs test1 type=string field=filename;
}
</pre>
Use ``/usr/local/nginx/sbin/nginx`` to start Nginx. And use parameter ``-s reload`` if you changed the configuration file again.

### 3, Python 
#### library version
 - Flask 0.10.1
 - Gevent 1.0.0
 - Gunicorn 0.18.0
 - pymongo 2.6.3
 
#### run application

<pre>
cd flaskapp/
sudo chmod +x runflask.sh
bash runflask.sh
</pre>
Script [``runflask.sh``](/flaskapp/runflask.sh) will start gunicorn with gevnet woker mode.
Gunicorn configuration file [here](/flask/gunicorncfg.py)


### 4, Node.js
#### library version
xxx

## Test Result



## Credits
