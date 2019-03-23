systemctl stop firewalld.service

cd / && nohup python -m SimpleHTTPServer 9127 > /tmp/httpserver.log &


#use alibaba yum repo
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup`date '+%Y%m%d_%H%M%S'` 
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache


#get netstat
yum -y install net-tools
yum -y vim

#get deps to compile python modules
yum -y install gcc automake autoconf libtool make
yum -y install gcc
yum -y install gcc-c++

cp /tmp/*.tar.gz /usr/local/src
cd /usr/local/src

nginx=/usr/local/nginx/nginx
#for url rewrite
if [ ! -e pcre.tar.gz ] ; then curl -k https://jaist.dl.sourceforge.net/project/pcre/pcre/8.34/pcre-8.34.tar.gz -o pcre.tar.gz ; fi
tar -zxvf pcre.tar.gz
if [ ! -e $nginx ] ; then cd pcre-8.34 && ./configure && make && make install ; fi

cd /usr/local/src
if [ ! -e zlib.tar.gz ] ; then curl -k https://nchc.dl.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz -o zlib.tar.gz ; fi
tar -zxvf zlib.tar.gz
if [ ! -e $nginx ] ; then cd zlib-1.2.11/ && ./configure && make && make install ; fi

cd /usr/local/src
if [ ! -e openssl.tar.gz ] ; then curl -k https://www.openssl.org/source/openssl-1.0.1t.tar.gz -o openssl.tar.gz ; fi
tar -zxvf openssl.tar.gz
cd openssl-1.0.1t/
./config shared zlib  --prefix=/usr/local/openssl 
if [ ! -e $nginx ] ; then make && make install ; fi

cd /usr/local/src
if [ ! -e nginx.tar.gz ] ; then curl http://nginx.org/download/nginx-1.4.2.tar.gz -o nginx.tar.gz ; fi
tar -zxvf nginx.tar.gz
cd nginx-1.4.2/
./configure --sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=/usr/local/src/pcre-8.34 \
--with-zlib=/usr/local/src/zlib-1.2.11 \
--with-openssl=/usr/local/src/openssl-1.0.1t
if [ ! -e $nginx ] ; then make && make install ; fi

ln -s $nginx /usr/bin/nginx

cd /usr/local/nginx && ls -rtla

#netstat -ano|grep 80
netstat -tulnp|grep 80
cd / && nohup /usr/local/nginx/nginx &
netstat -tulnp|grep 80|egrep -v '80[0-9]+'

netstat -tulnp|grep 8080
cp /usr/local/nginx/nginx.conf /usr/local/nginx/nginx.conf.bk`date '+%Y%m%d_%H%M%S'`
cd / && nohup /usr/local/nginx/nginx &
netstat -tulnp|grep 8080

echo "nginx is started"

cd /usr/local/src/
# https://npm.taobao.org/mirrors/node/v11.0.0/node-v11.0.0.tar.gz
#export node_version=10.15.3
#curl http://cdn.npm.taobao.org/dist/node/v${node_version}/node-v${node_version}.tar.gz -o node-v${node_version}.tar.gz
#tar -zxvf node-v${node_version}.tar.gz
#cd node-v${node_version}/
#./configure && make && make install

cd /usr/local/src
curl http://cdn.npm.taobao.org/dist/node/v10.15.3/node-v10.15.3-linux-x64.tar.gz  -o  node.tar.gz
tar -zxvf node.tar.gz
cd node-v10.15.3-linux-x64/
mv /usr/local/src/node-v10.15.3-linux-x64 /usr/local/node
tee /tmp/node.p << EOF
export NODE_HOME=/usr/local/node
export PATH=\$PATH:\$NODE_HOME/bin
export NODE_PATH=\$NODE_HOME/lib/node_modules
EOF
cat /tmp/node.p >> /etc/profile
source /etc/profile

npm config set registry https://registry.npm.taobao.org
npm install -g vue-cli
node -v
npm install restify

cd /tmp/app && npm install 
export APP_PORT=8085 && node /tmp/app/app.js &
export APP_PORT=8082 && node /tmp/app/app.js &
export APP_PORT=8083 && node /tmp/app/app.js &
export APP_PORT=8084 && node /tmp/app/app.js & 

cd /tmp
mv /usr/local/nginx/nginx.conf /usr/local/nginx/nginx.conf.bk`date '+%Y%m%d_%H%M%S'`
cp /tmp/nginx.conf  /usr/local/nginx/nginx.conf
nohup /usr/local/nginx/nginx &
