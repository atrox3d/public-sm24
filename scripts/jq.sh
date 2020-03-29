#!/bin/bash

################################################################################
#
#	load include
#
################################################################################
. functions.include
########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 2 ] || {
	echo "syntax $(basename $BASH_SOURCE) filename stores|slots [csv]"
	exit 1
}
ACTION=$2
CSV=$3
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
#	set queries
#
################################################################################
JQSTORES='.data.body[]'\
'| select(.widget_type | contains("vertical-list")).list[]'\
'| {
		locationID:.tracking[].data.location_id,
		storeID:.id,
		storeName:.name,
		storeAddress:.tracking[].data.store_address
}'
#
JQSLOTS='.data.data[].hours[] | .label'
################################################################################
#
#	set query
#
################################################################################
JQQUERY=
case $ACTION in
	stores)	
			echo stores;
			JQQUERY="$JQSTORES";;
	slots) 
			echo slots;
			JQQUERY="$JQSLOTS";;
	*) 
			echo ERROR;
			exit 1;;
esac
################################################################################
#
#	extract data
#
################################################################################
JQOUT="$( jq -rc "$JQQUERY" "$JSONFILE")"

#JQOUT="$(
#jq -rc \
#'.data.body[]'\
#'| select(.widget_type | contains("vertical-list")).list[]'\
#'| {
#		locationID:.tracking[].data.location_id,
#		storeID:.id,
#		storeName:.name,
#		storeAddress:.tracking[].data.store_address
#}' \
#"$JSONFILE"
#)"

[ -v CSV -a $ACTION == stores ] && {
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
