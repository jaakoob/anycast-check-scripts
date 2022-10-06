#!/bin/bash

usage() {
        echo "
Usage: dns-authoritative.sh [-s server] [-z zone]
Where:	server	is the dns server to be checked
	zone	is an authoritative zone to check
The script will check the existence of essential records within the zone (SOA).
If those records are not served by the supplied server or a timeout occurs, this
script will return a non-zero exit code.
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
        z)
            zone=${OPTARG}
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

result=$(dig SOA +tries=1 +time=1 $zone @$server)
dig_exit_code=$?

if [[ $dig_exit_code -ne 0 ]]; then
	exit $dig_exit_code
fi

case $result in
	*"status: REFUSED"*)
		exit 1
		;;
	*"status: SERVFAIL"*)
		exit 1
		;;
	*"status: NXDOMAIN"*)
		exit 1
		;;
	*"status: NOERROR"*)
		exit 0
		;;
esac
