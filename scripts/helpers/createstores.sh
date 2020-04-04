#!/bin/bash
# ./jq.sh ../data/***REMOVED***\@***REMOVED***/json/***REMOVED***.STORES.opera.json | while read -r a b c d; do echo -e "$a\t$b\t$c\t$d"; done
STARTPATH="$(pwd)"
SCRIPTPATH="$(dirname $(realpath $0))"
cd "$SCRIPTPATH"
SCRIPTNAME="$(basename $0)"
INCLUDEPATH="${SCRIPTPATH}/include"
INCLUDE="${INCLUDEPATH}/functions.include"
################################################################################
#                                                                              #
#	load include                                                               #
#                                                                              #
################################################################################
. "$INCLUDE" || { echo "ERROR|cannot source $INCLUDE"; exit 1; }

[ $# -ge 1 ] || { echo "syntax $BASH_SOURCE email"; exit 1; }

EMAIL="$1"


DATADIR="../../data/$EMAIL"
JSONDIR="${DATADIR}/json"
DATAFILE="${JSONDIR}/stores.json"

./jq.sh "$DATAFILE" | while read -r a b c d; do echo -e "$a\t$b\t$c\t$d"; done
