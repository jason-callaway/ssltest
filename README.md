# ssltest
Simple Docker image for testing SSL certificates

## Usage

Put your certificates in this directory as:
* ```server.crt```
* ```server.key```
* ```server-ca.crt``` (CA chain, not required for self-signed as below)

Then build ```docker build -t ssltest .```.

Run with ```docker run -d -p 443:443 ssltest```.

If you can cURL your container, your certs are good. Don't forget, if you're using Docker Machine, you'll need a tunnel.

Full example (on Mac OS X):

```

mbp:ssltest jason$ openssl req -x509 -sha256 -nodes -days 265 -newkey rsa:2048 -keyout server.key -out server.crt
Generating a 2048 bit RSA private key
.......+++
.................................................+++
writing new private key to 'server.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:Maryland
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:ssltest.example.com
Email Address []:
mbp:ssltest jason$ docker build -t ssltest .
Sending build context to Docker daemon 69.12 kB
Step 0 : FROM httpd
 ---> 1a49ac676c05
Step 1 : ADD *.crt /usr/local/apache2/conf/
 ---> 63b82768c737
Removing intermediate container c321f1b62915
Step 2 : ADD *.key /usr/local/apache2/conf/
 ---> b3702b9d3d12
Removing intermediate container e198f468c35d
Step 3 : RUN sed -i -e 's/^#Include conf\/extra\/httpd-ssl.conf/Include conf\/extra\/httpd-ssl.conf/' /usr/local/apache2/conf/httpd.conf &&     sed -i -e 's/^#LoadModule ssl_module modules\/mod_ssl.so/LoadModule ssl_module modules\/mod_ssl.so/' /usr/local/apache2/conf/httpd.conf &&     sed -i -e 's/^#LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/' /usr/local/apache2/conf/httpd.conf
 ---> Running in 36b6a984cf18
 ---> 8ed877c30276
Removing intermediate container 36b6a984cf18
Step 4 : EXPOSE 443
 ---> Running in 407970e8b8f0
 ---> afb32e5f58af
Removing intermediate container 407970e8b8f0
Step 5 : CMD httpd-foreground
 ---> Running in 4802e1f8e6e9
 ---> 288a037267d5
Removing intermediate container 4802e1f8e6e9
Successfully built 288a037267d5
mbp:ssltest jason$ # Password is tcuser
mbp:ssltest jason$ sudo ssh -f -T -N -L443:localhost:443 -l docker $(echo $DOCKER_HOST | cut -d ':' -f 2 | tr -d '/')
docker@192.168.99.100's password:
mbp:ssltest jason$ docker run -d -p 443:443 ssltest
5a4a8ad25925e4b0804d274f2270f0e83e2aa95b3e17ec279f6848de537cc8d3
mbp:ssltest jason$ curl --insecure https://localhost:443
<html><body><h1>It works!</h1></body></html>
```


