# Check Scripts

Scripts in this repo are intended to quickly check the responsiveness of remote services and return a non-zero exit
code, when the check fails. All scripts contain individual headers with instructions on how to use them
and an exact definition of what they do. 

These scripts are mainly meant to be used in combination with the [anycast_healthchecker](https://github.com/unixsurfer/anycast_healthchecker)
 from [unixsurfer](https://github.com/unixsurfer).

## Available scripts

| Script name | Description |
|---|---|
| *dns-authoritative.sh* | Check a DNS server which is supposed to be authoritative for a given zone. |
| *dns-recursor.sh*  | Check a DNS server which is supposed to act as recursor. |



