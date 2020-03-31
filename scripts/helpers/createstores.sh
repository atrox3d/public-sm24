#!/bin/bash
# ./jq.sh ../data/***REMOVED***\@***REMOVED***/json/***REMOVED***.STORES.opera.json | while read -r a b c d; do echo -e "$a\t$b\t$c\t$d"; done
################################################################################
#
#	load include
#
################################################################################
. functions.include

[ $# -ge 1 ] || { echo "syntax $BASH_SOURCE email"; exit 1; }

EMAIL="$1"


DATADIR="../../data/$EMAIL"
JSONDIR="${DATADIR}/json"
DATAFILE="${JSONDIR}/stores.json"

./jq.sh "$DATAFILE" | while read -r a b c d; do echo -e "$a\t$b\t$c\t$d"; done
