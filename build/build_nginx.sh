#!/bin/bash -e

#-----------------------------------------------------------------------
# Name........: build_nginx.sh
# Code repo...: github.com/arildjensen/scripts
# Author......: Arild Jensen <ajensen@counter-attack.com>
# Purpose.....: Build nginx the way I want it.
# Dependencies: gcc, make, zlib-dev, pcre-dev
# Usage.......: Run with no arguments. Do check whether the version
#               numbers need updating. Note the "make install" part
#               requires root.
#-----------------------------------------------------------------------

nginx_ver="1.5.12"
hmn_ver="0.25"

curl -O http://nginx.org/download/nginx-${nginx_ver}.tar.gz
curl -o headers-more-nginx-${hmn_ver}.tar.gz https://codeload.github.com/agentzh/headers-more-nginx-module/tar.gz/v${hmn_ver}
tar -xzvf nginx-${nginx_ver}.tar.gz
tar -xzvf headers-more-nginx-${hmn_ver}.tar.gz
rm        nginx-${nginx_ver}.tar.gz
rm        headers-more-nginx-${hmn_ver}.tar.gz

cd nginx-${nginx_ver}/
 
# Here we assume you would install you nginx under /opt/nginx/.
./configure --prefix=/opt/nginx \
    --add-module=../headers-more-nginx-module-${hmn_ver}/
 
make
make install
