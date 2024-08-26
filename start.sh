#!/bin/sh

export DUO_URL="$1"
export NSO_URL="$2"
echo "Duo metadata URL: "$DUO_URL
echo "NSO Web Interface Public Access URL: "$NSO_URL
./cisco-nso-saml2-auth.xml.gen $DUO_URL $NSO_URL



ncs_cli -C -u admin<< EOF
config
load replace cisco-nso-saml2-auth.xml
commit
exit no-confirm
exit
EOF


echo "Please update your Service Provider Settings on the DUO admin Panel with $NSO_URL as base URL"
