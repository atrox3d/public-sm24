#!/bin/bash

#./jq.sh ../opera/out/***REMOVED***.stores.opera.json \
#	| while read -r a b c d
#		do echo "$c, $d
#	done

################################################################################
#
#	load include
#
################################################################################
. functions.include
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
		storeID:.id,
		locationID:.tracking[].data.location_id,
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
	echo "$JQOUT" |  jq -cr '. | "\(.storeID) \(.locationID) \(.storeName) \(.storeAddress)"'
} || {
	echo "$JQOUT"
}


if iswindows
then
	popd  > /dev/null
fi
