#!/bin/bash

# Return the SSL key for given domain name.  make sure to chmod +x
# Donate to my caffeine fund: 19sttJCvFjmVyhdSmVpUZDz2ozGX1jZBYh

if [ $# -eq 0 ]
	then
		echo "Must provide server address.  Exiting."
		echo "Script will obtain servers SSL key and write it to a"
		echo "pem file for use in viewing captured https data streams."
		echo "USAGE: ./get_remote_ssl.sh www.example.com"
		
		exit 1
	else
		t=".certs" # File extension for temporary file containing server certificates.  Removed on cleanup
		c=$1$t	# Append .certs extension tp domain name text to create for example: www.example.com.certs
		openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null </dev/null > $c # Use OpenSSL to connect to and reteive server certificates and output to temp file
		e=".pem" # File extension for OpenSSL PEM file to be used to decrypt live or captured HTTPS data
		n=$1$e # Create final output name: www.example.com.pem
						
		sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p; /-----END CERTIFICATE-----/q' $c > $n # Pull only PEM certificate and discard all other data, write to final output file

		# cleanup
		rm *.certs
		
fi
