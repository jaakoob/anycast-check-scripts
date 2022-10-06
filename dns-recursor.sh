#!/bin/bash

usage() {
        echo "
Usage: dns-recursor.sh [-s server]
Where:	server	is the dns server to be checked
The script will check responses for some common websites
and DNS zones. Recent outages (facebook DNS) show, that
checking only one major vendor/ yourself is not sufficient
for DNS check scripts. For this check to mark an recursor
as unavailable all domains provided in the script do have
to return errors or no A records.
"
}

if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi


while getopts ":s:z:" opt; do
    case "${opt}" in
        s)
            server=${OPTARG}
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

QUERIES="www.google.com
www.facebook.com
www.microsoft.com
"

checks=0
fails=0

for domain in $QUERIES; do
	checks=$((checks + 1))
	result=$(dig A +tries=1 +time=1 $domain @$server)
	dig_exit_code=$?

	if [[ $dig_exit_code -ne 0 ]]; then
		# exit when dig return an error code
		# that means there was a timeout for the query
		exit $dig_exit_code
	fi

	case $result in
		*"status: REFUSED"*)
			fails=$((fails + 1))
			;;
		*"status: SERVFAIL"*)
			fails=$((fails + 1))
			;;
		*"status: NXDOMAIN"*)
			fails=$((fails + 1))
			;;
	esac
done

if [[ $checks -eq $fails ]]; then
	exit 1
fi
