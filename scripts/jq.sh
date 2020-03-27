#!/bin/bash
#jq -c '.data.body[] | select(.widget_type | contains("vertical-list")).list[] | {storeID:.id, storeName:.name, locationID:.tracking[].data.location_id, storeAddress:.tracking[].data.store_address}' ***REMOVED***.stores.opera.json

jq -c \
'.data.body[]'\
'| select(.widget_type | contains("vertical-list")).list[]'\
'| {
		storeID:.id,
		storeName:.name,
		locationID:.tracking[].data.location_id,
		storeAddress:.tracking[].data.store_address
}' \
../opera/out/***REMOVED***.stores.opera.json
#output/***REMOVED***.stores.opera.json



