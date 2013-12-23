## Purpose
[MongoDB GridFS](http://docs.mongodb.org/manual/core/gridfs/) comes with some natural advantages such as scalability(sharding) and HA(replica set). But as it stores file in ASCII string chunks, there's no doubt a performance loss.

I'm trying 3 different deployments (different MongoDB drivers) to read from GridFS. And compare the results to classic Nginx configuration.


## Credits
[Neil Chen](https://github.com/neilchencn) (neil.chen.nj@gmail.com) 

## Configurations

### 1, Nginx
<pre>
location /files/ {
  alias /home/ubuntu/;
} 
</pre>
``open_file_cache`` kept ``off`` during the test.

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
 - Node.js 0.10.4
 - Express 3.4.7
 - mongodb(driver) 1.3.23

#### run application

<pre>
cd nodejsapp/
sudo chmod +x runnodejs.sh
bash runnodejs.sh
</pre>


## Test

### Test items:
>
 1. file served by Nginx directly 
 2. file served by Nginx_gridFS + GridFS
 3. file served by Flask + pymongo + gevent + GridFS
 4. file served by Node.js + GridFS

### Files for downloading:
Run script [insert_file_gridfs.py](/insert_file_gridfs.py) from MongoDB server to insert 4 different size of file to database <strong>test1</strong>(``pymongo`` is required)
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

### Concurrency
100 concurrent requests, total 500 requests.
<pre>
ab -c 100 -n 500 ...
</pre>

## Result
### Throughput
Time per request (download)

File size | Nginx+Hard drive | Nginx+GridFS plugin | Python(pymongo+gevent) | Node.js
--- | --- | --- | --- | ---
**1KB** | 0.174 | 1.124 | 1.982 | 1.679 
**100KB** | 1.014 | 1.572 | 3.103 | 3.708
**1MB** | 9.582 | 9.567 | 15.973 | 18.317

You can get Apache ab report in folder: [``testresult``](/testresult)


### Server load
The server load is be monitored by command:
<code>
vmstat 2
</code> 

**Nginx:**

 ![Nginx](https://raw.github.com/feifangit/MongoDB-GridFS-test/master/testresult/nginx_log-01-cpuchart.png)

**Nginx_gridfs**

 ![Nginx](https://raw.github.com/feifangit/MongoDB-GridFS-test/master/testresult/nginx_gridfs-01-cpuchart.png)

**gevent+pymongo**

 ![Nginx](https://raw.github.com/feifangit/MongoDB-GridFS-test/master/testresult/pymongo_-01-cpuchart.png)

**Node.js**

 ![Nginx](https://raw.github.com/feifangit/MongoDB-GridFS-test/master/testresult/node-01-cpuchart.png)


### Conclusion
 - Files served by Nginx directly
 
>
  - No doubt it's the most efficient one, whether performance or server load. 
  - Support cache. In real world, the directive ``open_file_cache`` should be configured well for better performance. 
  - And must mention, it's the only one support pause and resume during the download(HTTP range support). 

 - For the rest 3 test items, files are stored in MongoDB, but served by different drivers. 

>
 - serve static files by application is really not an appropriate choice. They drains CPU too much and the performance is not good. 
 - nginx_gridfs (MongoDB C driver): downloading requests will be processed at Nginx level, which is in front of web applications in most deployments. Web application can focus on processing dynamic contents instead of static content. 
 - nginx_gridfs got the best performance comparing to other applications written in script languages. - The performance differences between Nginx and nginx_gridfs getting small after file size increased. But you can not turn a blind eye on the server load.
 - pymongo and node.js driver: it's a draw game. Static files should be avoid to be served in productive applications.
  



#### Advantages of GridFS
 - Put files in database make static content management much easier. We can omit maintain the consistency between files and its meta data in database.
 - Scalable and HA advantages come with MongoDB

#### Drawbacks of GridFS
 - bad performance
 - can not resume downloading after pause or break

#### When should I use MongoDB GridFS
There are rare use cases I can imagine, especially in a performance sensitive system. But I may taste it in some prototype projects. 

Here goes the answer from MongoDB official website, hope this will help.
[http://docs.mongodb.org/manual/faq/developers/#faq-developers-when-to-use-gridfs](http://docs.mongodb.org/manual/faq/developers/#faq-developers-when-to-use-gridfs)
