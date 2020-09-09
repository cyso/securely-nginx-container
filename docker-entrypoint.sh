#!/bin/bash

# Set default values if not set
set -a
: ${PARANOIA:=1}
: ${EXECUTING_PARANOIA:=2}
: ${ANOMALYIN:=5}
: ${ANOMALYOUT:=4}
: ${PORT:=8001}
: ${BACKEND:="http://172.17.0.1:8000"}
: ${FQDN:=localhost}
: ${SEC_RULE_ENGINE:=On}
set +a

# Paranoia Level
$(python <<EOF
import re
import os
out=re.sub('(#SecAction[\S\s]{7}id:900000[\s\S]*tx\.paranoia_level=1\")','SecAction \\\\\n  \"id:900000, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:tx.paranoia_level='+os.environ['PARANOIA']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Executing Paranoia Level
$(python <<EOF
import re
import os
if "EXECUTING_PARANOIA" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{7}id:900001[\s\S]*tx\.executing_paranoia_level=1\")','SecAction \\\\\n  \"id:900001, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:tx.executing_paranoia_level='+os.environ['EXECUTING_PARANOIA']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Enforce Body Processor URLENCODED
$(python <<EOF
import re
import os
if "ENFORCE_BODYPROC_URLENCODED" in os.environ:
   out=re.sub('(#SecAction[\S\s]{7}id:900010[\s\S]*tx\.enforce_bodyproc_urlencoded=1\")','SecAction \\\\\n  \"id:900010, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:tx.enforce_bodyproc_urlencoded='+os.environ['ENFORCE_BODYPROC_URLENCODED']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Inbound and Outbound Anomaly Score
$(python <<EOF
import re
import os
out=re.sub('(#SecAction[\S\s]{6}id:900110[\s\S]*tx\.outbound_anomaly_score_threshold=4\")','SecAction \\\\\n  \"id:900110, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:tx.inbound_anomaly_score_threshold='+os.environ['ANOMALYIN']+','+'  \\\\\n   setvar:tx.outbound_anomaly_score_threshold='+os.environ['ANOMALYOUT']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# HTTP methods that a client is allowed to use.
$(python <<EOF
import re
import os
if "ALLOWED_METHODS" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900200[\s\S]*\'tx\.allowed_methods=[A-Z\s]*\'\")','SecAction \\\\\n  \"id:900200, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.allowed_methods='+os.environ['ALLOWED_METHODS']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Content-Types that a client is allowed to send in a request.
$(python <<EOF
import re
import os
if "ALLOWED_REQUEST_CONTENT_TYPE" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900220[\s\S]*\'tx.allowed_request_content_type=[a-z|\-\+\/]*\'\")','SecAction \\\\\n  \"id:900220, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.allowed_request_content_type='+os.environ['ALLOWED_REQUEST_CONTENT_TYPE']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Content-Types charsets that a client is allowed to send in a request.
$(python <<EOF
import re
import os
if "ALLOWED_REQUEST_CONTENT_TYPE_CHARSET" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900270[\s\S]*\'tx.allowed_request_content_type_charset=[|\-a-z0-9]*\'\")','SecAction \\\\\n  \"id:900270, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.allowed_request_content_type_charset='+os.environ['ALLOWED_REQUEST_CONTENT_TYPE_CHARSET']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Allowed HTTP versions.
$(python <<EOF
import re
import os
if "ALLOWED_HTTP_VERSIONS" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900230[\s\S]*\'tx.allowed_http_versions=[HTP012\/\.\s]*\'\")','SecAction \\\\\n  \"id:900230, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.allowed_http_versions='+os.environ['ALLOWED_HTTP_VERSIONS']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Forbidden file extensions.
$(python <<EOF
import re
import os
if "RESTRICTED_EXTENSIONS" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900240[\s\S]*\'tx.restricted_extensions=[\.a-z\s\/]*\/\'\")','SecAction \\\\\n  \"id:900240, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.restricted_extensions='+os.environ['RESTRICTED_EXTENSIONS']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Forbidden request headers.
$(python <<EOF
import re
import os
if "RESTRICTED_HEADERS" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900250[\s\S]*\'tx.restricted_headers=[a-z\s\/\-]*\'\")','SecAction \\\\\n  \"id:900250, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.restricted_headers='+os.environ['RESTRICTED_HEADERS']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# File extensions considered static files.
$(python <<EOF
import re
import os
if "STATIC_EXTENSIONS" in os.environ:
   out=re.sub('(#SecAction[\S\s]{6}id:900260[\s\S]*\'tx.static_extensions=\/[a-z\s\/\.]*\'\")','SecAction \\\\\n  \"id:900260, \\\\\n   phase:1, \\\\\n   nolog, \\\\\n   pass, \\\\\n   t:none, \\\\\n   setvar:\'tx.static_extensions='+os.environ['STATIC_EXTENSIONS']+'\'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if number of arguments is too high
$(python <<EOF
import re
import os
if "MAX_NUM_ARGS" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900300[\s\S]*tx\.max_num_args=255\")','SecAction \\\\\n \"id:900300, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.max_num_args='+os.environ['MAX_NUM_ARGS']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if the length of any argument name is too high
$(python <<EOF
import re
import os
if "ARG_NAME_LENGTH" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900310[\s\S]*tx\.arg_name_length=100\")','SecAction \\\\\n \"id:900310, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.arg_name_length='+os.environ['ARG_NAME_LENGTH']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if the length of any argument value is too high
$(python <<EOF
import re
import os
if "ARG_LENGTH" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900320[\s\S]*tx\.arg_length=400\")','SecAction \\\\\n \"id:900320, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.arg_length='+os.environ['ARG_LENGTH']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if the total length of all combined arguments is too high
$(python <<EOF
import re
import os
if "TOTAL_ARG_LENGTH" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900330[\s\S]*tx\.total_arg_length=64000\")','SecAction \\\\\n \"id:900330, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.total_arg_length='+os.environ['TOTAL_ARG_LENGTH']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if the total length of all combined arguments is too high
$(python <<EOF
import re
import os
if "MAX_FILE_SIZE" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900340[\s\S]*tx\.max_file_size=1048576\")','SecAction \\\\\n \"id:900340, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.max_file_size='+os.environ['MAX_FILE_SIZE']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Block request if the total size of all combined uploaded files is too high
$(python <<EOF
import re
import os
if "COMBINED_FILE_SIZES" in os.environ: 
   out=re.sub('(#SecAction[\S\s]{6}id:900350[\s\S]*tx\.combined_file_sizes=1048576\")','SecAction \\\\\n \"id:900350, \\\\\n phase:1, \\\\\n nolog, \\\\\n pass, \\\\\n t:none, \\\\\n setvar:tx.combined_file_sizes='+os.environ['COMBINED_FILE_SIZES']+'\"',open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','r').read())
   open('/etc/modsecurity.d/owasp-crs/crs-setup.conf','w').write(out)
EOF
) && \

# Set Listen Port
$(python <<EOF
import re
import os
out=re.sub('(Listen\s+8001)','Listen            '+os.environ['PORT'],open('/etc/apache2/conf/httpd.conf','r').read())
open('/etc/apache2/conf/httpd.conf','w').write(out)
EOF
) && \

#Update template for the Backend Virtual Host to where we proxy the incoming requests
$(python <<EOF
import re
import os

AUTOGENERATED_COMMENT = '# Automatically generated based on BACKEND and FQDN environment variables\n\n'

backendset = os.environ['BACKEND'].split(',')
fqdnset = os.environ['FQDN'].split(',')

assert len(backendset) == len(fqdnset), 'The Backend and FQDN list must have the same number of entries'

open('/etc/apache2/conf/httpd.conf','a').write(AUTOGENERATED_COMMENT)

for i in range(len(backendset)):
    template = open('/etc/apache2/conf/httpd-virtualhost.tpl','r').read()

    template = re.sub('(TEMPLATE_LOCATION)', backendset[i], template)
    template = re.sub('(TEMPLATE_PORT)', os.environ['PORT'], template)
    template = re.sub('(TEMPLATE_FQDN)', fqdnset[i], template)

    open('/etc/apache2/conf/httpd.conf','a').write(template)
EOF
) && \

if [ ! -z $PROXY ]; then
  if [ $PROXY -eq 1 ]; then
    APACHE_ARGUMENTS='-D crs_proxy'
    if [ -z "$UPSTREAM" ]; then
      export UPSTREAM=$(/sbin/ip route | grep ^default | perl -pe 's/^.*?via ([\d.]+).*/$1/g'):81
    fi
  fi
fi && \

if [[ -v STDOUT ]]; then
  sed -ri \
      -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
      -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
      -e 's!^(\s*TransferLog)\s+\S+!\1 /proc/self/fd/1!g' \
      "/etc/apache2/conf/httpd.conf" &&
  sed -ri \
      -e 's!^(\s*SecAuditLog)\s+\S+!\1 /proc/self/fd/1!g' \
      "/etc/modsecurity.d/modsecurity.conf"
elif [ -v FILEBEAT ]; then
  FILEBEAT_PIPE=/tmp/filebeat_pipe

  if [[ ! -p $FILEBEAT_PIPE ]]; then
    mkfifo $FILEBEAT_PIPE
  fi

  cat < $FILEBEAT_PIPE | grep -v -e "State" -e "error retrieving process stats" &

  sed -ri \
      -e 's!^(\s*CustomLog)\s+\S+!\1 "|$/usr/bin/filebeat -e -E FILEBEAT_MODULE=apache -E FILEBEAT_DATASET=apache.access -path.data /tmp/filebeat-apache-access-$(date +%s%3N) 2>/tmp/filebeat_pipe" !g' \
      -e 's!^(\s*ErrorLog)\s+\S+!\1 "|$/usr/bin/filebeat -e -E FILEBEAT_MODULE=apache -E FILEBEAT_DATASET=apache.error -path.data /tmp/filebeat-apache-error-$(date +%s%3N) 2>/tmp/filebeat_pipe" !g' \
      -e 's!^(\s*TransferLog)\s+\S+!\1 "|$/usr/bin/filebeat -e -E FILEBEAT_MODULE=apache -E FILEBEAT_DATASET=apache.transfer -path.data /tmp/filebeat-apache-transfer-$(date +%s%3N) 2>/tmp/filebeat_pipe" !g' \
      "/etc/apache2/conf/httpd.conf" &&
  sed -ri \
      -e 's!^(\s*SecAuditLog)\s+\S+!\1 "|$/usr/bin/filebeat -e -E FILEBEAT_MODULE=modsecurity -E FILEBEAT_DATASET=modsecurity.json -path.data /tmp/filebeat-modsecurity-$(date +%s%3N) 2>/tmp/filebeat_pipe" !g' \
      "/etc/modsecurity.d/modsecurity.conf"
fi && \

if [[ -v SECURELY ]]; then
  /usr/local/securely-blocker -file /etc/securely-blocker-db -file_post_command "test -f /var/run/apache.pid && $* -k graceful $APACHE_ARGUMENTS" &
fi && \

exec "$@" $APACHE_ARGUMENTS
