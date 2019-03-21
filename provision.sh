yum -y install gcc automake autoconf libtool make
yum install gcc gcc-c++


cd /usr/local/src

#curl -k -s https://jaist.dl.sourceforge.net/project/pcre/pcre/8.37/pcre-8.37.tar.gz -o pcre.tar.gz
#curl -k -s https://nchc.dl.sourceforge.net/project/pcre/pcre/8.34/pcre-8.34.tar.gz -o pcre.tar.gz
curl -k https://jaist.dl.sourceforge.net/project/pcre/pcre/8.34/pcre-8.34.tar.gz -o pcre.tar.gz
tar -zxvf pcre.tar.gz
cd pcre-8.34
./configure
make
make install

cd /usr/local/src
curl -k https://nchc.dl.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz -o zlib.tar.gz
tar -zxvf zlib.tar.gz
cd zlib-1.2.11/
./configure
make
make install

cd /usr/local/src
curl -k https://www.openssl.org/source/openssl-1.0.1t.tar.gz -o openssl.tar.gz
tar -zxvf openssl.tar.gz
cd openssl-1.0.1t/
./config shared zlib  --prefix=/usr/local/openssl   
make
make install

cd /usr/local/src
curl http://nginx.org/download/nginx-1.4.2.tar.gz -o nginx.tar.gz
tar -zxvf nginx.tar.gz
cd nginx-1.4.2/
./configure --sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_ssl_module \
--with-pcre=/usr/local/src/pcre-8.34 \
--with-zlib=/usr/local/src/zlib-1.2.11 \
--with-openssl=/usr/local/src/openssl-1.0.1t
make
make install

cd /usr/local/nginx && ls -rtla

netstat -ano|grep 80

/usr/local/nginx/nginx
