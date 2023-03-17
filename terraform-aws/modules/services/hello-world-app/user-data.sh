#!/bin/bash

cat > index.html <<EOF
<h1>${server_text}</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

# use 'busybox' to launch a 'tiny' deployment of httpd web server
nohup busybox httpd -f -p ${server_port} &
