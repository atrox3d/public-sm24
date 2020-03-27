#!/bin/bash
#jq -c '.data.body[] | select(.widget_type | contains("vertical-list")).list[] | {storeID:.id, storeName:.name, locationID:.tracking[].data.location_id, storeAddress:.tracking[].data.store_address}' ***REMOVED***.stores.opera.json

. functions.include

JSONFILE=../opera/out/***REMOVED***.stores.opera.json

if iswindows
then
	DIRNAME="$(dirname "$JSONFILE")"
	JSONFILE="$(basename "$JSONFILE")"
	pushd "$DIRNAME"
fi

jq -c \
'.data.body[]'\
'| select(.widget_type | contains("vertical-list")).list[]'\
'| {
		storeID:.id,
		storeName:.name,
		locationID:.tracking[].data.location_id,
		storeAddress:.tracking[].data.store_address
}' \
"$JSONFILE"

if iswindows
then
	popd
fi
