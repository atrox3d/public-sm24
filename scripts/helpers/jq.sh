#!/bin/bash

#./jq.sh ../opera/out/***REMOVED***.stores.opera.json \
#	| while read -r a b c d
#		do echo "$c, $d
#	done
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
########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 1 ] || {
	echo "syntax $(basename $BASH_SOURCE) filename [csv]"
	exit 1
}
CSV=$2
################################################################################
#
#	OS aware filename
#
################################################################################
#JSONFILE=../opera/out/***REMOVED***.stores.opera.json
JSONFILE="$1"
if iswindows
then
	DIRNAME="$(dirname "$JSONFILE")"
	JSONFILE="$(basename "$JSONFILE")"
	pushd "$DIRNAME" > /dev/null
fi
################################################################################
#
#	extract data
#
################################################################################
JQOUT="$(
jq -rc \
'.data.body[]'\
'| select(.widget_type | contains("vertical-list")).list[]'\
'| {
		locationID:.tracking[].data.location_id,
		storeID:.id,
		storeName:.name,
		storeAddress:.tracking[].data.store_address
}' \
"$JSONFILE"
)"

[ -v CSV ] && {
	#echo "$JQOUT" |  jq -rc "[ .storeID, .storeName, .locationID, .storeAddress ] | @csv"
	#echo "$JQOUT" |  jq -c '[ .storeID, .storeName, .locationID, .storeAddress ]' 
	#| jq -rc '.[0] + " " + .[1]'
	#echo "$JQOUT" |  jq -cr '. | "\(.storeID) \(.storeName) \(.locationID) '\''\(.storeAddress)'\''"'
	echo "$JQOUT" |  jq -cr '. | "\(.locationID) \(.storeID) \(.storeName) \(.storeAddress)"'
} || {
	echo "$JQOUT"
}


if iswindows
then
	popd  > /dev/null
fi
