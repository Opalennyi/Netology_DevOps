#!/bin/bash
# display command line options
# pushing master further
# another comment, keep pushing

count=1
while [[ -n "$1" ]]; do
    echo "Parameter #$count = $1"
    count=$(( $count + 1 ))
    shift
done






























