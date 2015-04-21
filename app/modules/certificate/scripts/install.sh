#!/bin/bash

MODULE_NAME="certificate"
MODULESCRIPT="cert_check"
MODULE_CACHE_FILE="certificate.txt"

CTL="${BASEURL}index.php?/module/${MODULE_NAME}/"

# Get the scripts in the proper directories
echo "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"
${CURL} "${CTL}get_script/${MODULESCRIPT}" -o "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

# Check exit status of curl
if [ $? = 0 ]; then
	# Make executable
	chmod a+x "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Set preference to include this file in the preflight check
	defaults write "${PREFPATH}" ReportItems -dict-add $MODULE_NAME "${CACHEPATH}${MODULE_CACHE_FILE}"

else
	echo "Failed to download all required components!"
	rm -f "${MUNKIPATH}preflight.d/${MODULESCRIPT}"

	# Signal that we had an error
	ERR=1
fi
