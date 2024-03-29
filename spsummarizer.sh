#!/bin/bash

set -o nounset
set -o pipefail

VERSION=0.2
PCAP=$1
IFS=$'\n'
TOOLDIR=$(dirname $0)

# Verifying that parameters were given
if [ -z "$1" ];
then
    echo "Simple Pcap Analyzer. Version $VERSION. Author: Veronica Valeros (@verovaleros)."
    echo
    echo usage: $0 [pcap]
    echo e.g. $0 capture.pcap
    echo
    exit
fi


echo "Simple Pcap Analyzer. Version $VERSION. Author: Veronica Valeros (@verovaleros)."
echo

echo -e "## PCAP General Summary\n"
echo
echo "\`\`\`"
capinfos $PCAP 2>/dev/null  |grep "name:\|packets:\|size:\|duration:\|packet time\|SHA256"
echo "\`\`\`"
echo

echo "### Top Uploads"
echo
echo "| Origin | <-> | Destination | Download | Upload | Total Transferred |"
echo "| -------|:---:|-------- | -------:| -------:| -------: |"
tshark -qzconv,ipv4 -r $PCAP  2>/dev/null |head -n 10 |grep -v "|\|IPv4\|Filter\|===" |awk '{print "| "$1" | <-> | "$3" | "$5" | "$7" | "$9" |"}'
echo

echo "### DNS Requests (Top 30)"
echo
tcpdump -nn -s0 -r $PCAP dst port 53 2>/dev/null |awk -F? '{print $2}' |awk -F "(" '{print $1}' | sort| uniq -c | sort -n -k 1 -r  |head -n 30 | sed 's/^/    /'
echo


echo "### HTTP Hosts"
echo
tcpdump -nn -s0 -r $PCAP dst port 80 -A 2>/dev/null | grep "Host: " | awk '{print $2}'| awk -F\. '{print $(NF-1)"."$(NF)}' |sort|uniq | sed 's/^/    /'
echo

echo "### User-Agents"
echo
USERAGENTS=$(tcpdump -nn -s0 -r $PCAP dst port 80 -A 2>/dev/null |grep "User-Agent: " |awk -F "User-Agent: " '{print $2}'|sort | uniq | sed 's/^/    /')
for UA in $USERAGENTS
do
    UA_OS=$(python3 $TOOLDIR/modules/mod_useragent.py $UA)
    echo "-$UA"
    echo "    - Information extracted: $UA_OS"
done
echo

echo "### HTTP GET Info Leaked"
echo
tcpdump -nn -s0 -r $PCAP -A port 80 and 'tcp[13] & 8 != 0' 2>/dev/null |grep "HTTP:\ GET\ /\|HTTP:\ POST\ /"|grep "?\|=" | awk -F "T " '{print $2}'|sort |uniq |sed 's/^/    /'
echo

echo "### Other Information Leak"
echo
tcpdump -nn -s0 -r $PCAP port 80 -A 2>/dev/null |grep "\":{\""| grep -i "wifi\|chrome\|access\|en\|cz\|es\|lang\|com\|loc\|lat\|lon\|imei\|mn\|android\|ios\|build\|time\|format\|[0-9][0-9]\."|sort|uniq -c |sort -n -k 1 -r | sed 's/^/     /'
