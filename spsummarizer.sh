#!/bin/bash

VERSION=0.1
PCAP=$1

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

# Obtain size of the Pcap
PCAP_SIZE=$(du -h $PCAP |cut -f1)

# Obtain number of packets
PCAP_PKTS=$(tcpdump -nn -r $PCAP 2>/dev/null | wc -l)

# Timestamp first packet: 
T1=$(tcpdump -tt -nn -s0 -r $PCAP 2>/dev/null |head -n 1 | awk -F " IP" '{print $1}'|awk -F\. '{print $1}')

# Timestamp last packet: 
T2=$(tcpdump -tt -nn -s0 -r $PCAP 2>/dev/null |tail -n 1 | awk -F " IP" '{print $1}'|awk -F\. '{print $1}')

# Calculate PCAP Duration
PCAP_DUR=$(( ( $T2 - $T1 ) / 3600 ))


echo "PCAP General Summary"
echo "===================="
echo "Size: $PCAP_SIZE    Packets: $PCAP_PKTS    Duration: $PCAP_DUR hs    Last Seen Packet: $(date -d@"$T2")"
