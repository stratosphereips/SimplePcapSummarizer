#!/bin/bash
VERSION=0.1

echo "Simple Pcap Analyzer. Version $VERSION. Author: Veronica Valeros (@verovaleros)."

pcapfile=$1

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

