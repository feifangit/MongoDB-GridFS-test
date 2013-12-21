## Purpose
[MongoDB GridFS](http://docs.mongodb.org/manual/core/gridfs/) comes with some natural advantages such as scalability(sharding) and HA(replica set). But as it stores file as ASCII string, there's no doubt a performance loss.

I'm just comparing performance by different deployment .


### Test items:
>
 1. file served by Nginx directly 
 2. file served by Nginx_gridFS + GridFS
 3. file served by Flask + gevent + GridFS
 4. file served by Node.js + GridFS

### Files for downloading:
Run script [insert_file_gridfs.py](/insert_file_gridfs.py) from MongoDB server to insert 4 different size of file to database <strong>test1</strong>

pymongo is required
>
 - 1KB
 - 100KB
 - 1MB
 - 100MB

### Test Environment
3 servers for MongoDB, Application server, and tester(JMeter), they're using the hardware:
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
I made a quick [install script](/nginx_gridfs_install.sh) in this repo. 
#### Configuration
<pre>
location /gridfsfn/{
   gridfs test1 type=string field=filename;
   mongo 127.0.0.1:27017;
}
</pre>

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

### 4, Node.js
#### library version
xxx

## Test Result



## Credits
