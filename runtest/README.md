I used apache ab for the testing. There's a [Jmeter project file](/performance.jmx).
### install Jmeter
<pre>
wget http://www.bizdirusa.com/mirrors/apache//jmeter/binaries/apache-jmeter-2.10.tgz
tar -xvf apache-jmeter-2.10.tgz
</pre>

### Start test 
run commands like following:
<pre>
jmeter -t performance.jmx -n -Jusernumber=10  -Jloopcount=2 -Jtargetip=127.0.0.1 -Jtargetport=5000 -Jtargeturl=/getfile/1k/ -Jlogname=1.jtl
</pre>

 - ``usernumber`` concurrency number
 - ``loopcount`` how many test to be run on each connection
 - ``targetip`` , ``targetport`` , ``targeturl`` service IP, port and URL information
 - ``logname`` log file, can be opened with Jmeter GUI