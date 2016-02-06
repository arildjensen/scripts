#!/bin/bash -e

#-----------------------------------------------------------------------
# Name........: build_nginx.sh
# Author......: Arild Jensen <arildjensen@upwork.com>
# Purpose.....: A custom build of nginx with extra modules
# Dependencies: gcc, make, zlib-dev, pcre-dev
# Usage.......: Run with no arguments. Do check whether the version
#               numbers need updating. Note the "make install" part
#               requires root.
#-----------------------------------------------------------------------

nginx_ver="1.8.1"
hmn_ver="0.29"
ngx_lua_ver="0.10.0"
ngx_devel_kit_ver="0.2.19"
lua_nginx_ver="0.10.0"

export LUAJIT_LIB=/tmp/lj2/lib
export LUAJIT_INC=/tmp/lj2/include/luajit-2.0

mkdir /tmp/$$
cd    /tmp/$$
echo  /tmp/$$

curl -O http://nginx.org/download/nginx-${nginx_ver}.tar.gz
curl -o headers-more-nginx-${hmn_ver}.tar.gz https://codeload.github.com/agentzh/headers-more-nginx-module/tar.gz/v${hmn_ver}
curl -O http://luajit.org/download/LuaJIT-2.0.4.tar.gz
curl -o ngx_devel_kit-${ngx_devel_kit_ver}.tar.gz https://codeload.github.com/simpl/ngx_devel_kit/tar.gz/v0.2.19
curl -o lua_nginx-${lua_nginx_ver}.tar.gz https://codeload.github.com/openresty/lua-nginx-module/tar.gz/v0.10.0
tar -xzvf nginx-${nginx_ver}.tar.gz
tar -xzvf headers-more-nginx-${hmn_ver}.tar.gz
tar -xzvf LuaJIT-2.0.4.tar.gz
tar -xzvf ngx_devel_kit-${ngx_devel_kit_ver}.tar.gz
tar -xzvf lua_nginx-${lua_nginx_ver}.tar.gz
rm        nginx-${nginx_ver}.tar.gz
rm        headers-more-nginx-${hmn_ver}.tar.gz
rm        LuaJIT-2.0.4.tar.gz
rm        ngx_devel_kit-${ngx_devel_kit_ver}.tar.gz
rm        lua_nginx-${lua_nginx_ver}.tar.gz

cd /tmp/$$/LuaJIT-2.0.4
make
make install PREFIX=/tmp/lj2


cd /tmp/$$/nginx-${nginx_ver}/
 
# Here we assume you would install you nginx under /opt/nginx/.
./configure --prefix=/opt/nginx \
    --add-module=../headers-more-nginx-module-${hmn_ver}/ \
    --add-module=../ngx_devel_kit-${ngx_devel_kit_ver}/ \
    --add-module=../lua-nginx-module-${lua_nginx_ver}

 
make
#make install
