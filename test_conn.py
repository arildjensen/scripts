#!/usr/bin/env python

########################################################################
# AUTHOR:
#   Arild Jensen <arildjensen@yahoo.com>
#   2012-12-15
#
# USAGE:
#   Run via cron to obtain metrics from the OS 'ping' command and
#   submit those to SplunkStorm (you will need an account there).
#
# NOTE:
#   This script used the subprocess function as you can't generate ICMP
#   packets in Python without running as root.
########################################################################

import urllib
import urllib2
import subprocess
import ConfigParser

# Read SplunkStorm and IP address settings from config file
config = ConfigParser.RawConfigParser()
config.read('test_conn.cfg')

access_token = config.get('SplunkStorm','access_token')
project_id   = config.get('SplunkStorm','project_id')
target       = config.get('IP Address','target') 
message = ''
debug = True
########################################################################

# Class to submit data to Splunk Storm (copied from splunkstorm.com)
class StormLog(object):

    def __init__(self, access_token, project_id, input_url=None):
        self.url = input_url or 'https://api.splunkstorm.com/1/inputs/http'
        self.project_id = project_id
        self.access_token = access_token

        self.pass_manager = urllib2.HTTPPasswordMgrWithDefaultRealm()
        self.pass_manager.add_password(None, self.url, '', access_token)
        self.auth_handler = urllib2.HTTPBasicAuthHandler(self.pass_manager)
        self.opener = urllib2.build_opener(self.auth_handler)
        urllib2.install_opener(self.opener)

    def send(self, event_text, sourcetype='syslog', host=None, source=None):
        params = {'project': self.project_id,
                  'sourcetype': sourcetype}
        if host:
            params['host'] = host
        if source:
            params['source'] = source
        url = '%s?%s' % (self.url, urllib.urlencode(params))
        try:
            req = urllib2.Request(url, event_text)
            response = urllib2.urlopen(req)
            return response.read()
        except (IOError, OSError), ex:
            # An error occured during URL opening or reading
            raise
########################################################################

# Execute ping command and capture the output
ping_cmd   = "ping -c 10 %s" % target
proc       = subprocess.Popen([ping_cmd], stdout=subprocess.PIPE, shell=True)
(out, err) = proc.communicate()

# Parse the output to obtain the metrics
spos = out.find("received, ")+10
epos = out.find("% packet loss")
packet_loss_pct = out[spos:epos]

spos = out.find("mdev = ")+7
epos = out.find(" ms",spos)
rtt_out = out[spos:epos]

spos = 0
epos = rtt_out.find("/")
rtt_min = rtt_out[spos:epos]

spos = epos+1
epos = rtt_out.find("/",spos)
rtt_avg = rtt_out[spos:epos]

spos = epos+1
epos = rtt_out.find("/",spos)
rtt_max = rtt_out[spos:epos]

spos = epos+1
rtt_mdev = rtt_out[spos:]

message = "target=%s packet_loss_pct=%s rtt_min=%s rtt_avg=%s rtt_max=%s rtt_mdev=%s" \
            % (target,packet_loss_pct,rtt_min,rtt_avg,rtt_max,rtt_mdev)

# Output to screen or to SplunkStorm
if (debug):
    print out
    print message
else:
    log = StormLog(access_token,project_id)
    log.send(message) 

########################################################################
