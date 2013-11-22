#!/bin/bash -e

#-----------------------------------------------------------------------
# Name.....: logstash_create_rpm.sh
# Code repo: github.com/arildjensen/scripts
# Author...: Arild Jensen <ajensen@counter-attack.com>
# Purpose..: Creates an RPM for LogStash, including downloading code and
#            setting up basic configuration.
# Usage....: Run with no arguments.
#-----------------------------------------------------------------------

jarurl=https://download.elasticsearch.org/logstash/logstash/logstash-1.2.2-flatjar.jar
initurl=http://cookbook.logstash.net/recipes/using-init/logstash.sh
#kiburl=https://download.elasticsearch.org/kibana/kibana/kibana-3.0.0milestone4.tar.gz

# Setup temporary area to create tar archive
mkdir -p /tmp/$$/opt/logstash
mkdir -p /tmp/$$/etc/init.d

# Download Logstash jar file
cd /tmp/$$/opt/logstash
curl -O $jarurl

# Download Logstash init script
cd /tmp/$$/etc/init.d
curl -O $initurl
mv logstash.sh logstash

# Create basic config file
cat <<'EOF' > /tmp/$$/opt/logstash/logstash.conf
chmod 755 logstash
input {
  tcp {
    port => 5544
    type => syslog
  }
  udp {
    port => 5544
    type => syslog
  }
}

output {
  elasticsearch { }
}
EOF

cd /tmp/$$/opt/logstash
ln -s logstash-1.2.2-flatjar.jar logstash-monolithic.jar

# Tar everything up. Tar file is used by the RPMbuild process.
cd /tmp/$$
tar cvpzf /tmp/logstash.tar.gz *
