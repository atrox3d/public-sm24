#!/bin/bash

#while read -r a b c; do echo "$a, $b, $c";done < credentials

########################################################################################################
#
#	starts always in debug unless $3 == EXECUTE
#
########################################################################################################
DEBUG=echo
[ $# -gt 3 ] && {
	[ $4 == EXECUTE ] && {
		DEBUG=
	}
}
########################################################################################################
#
########################################################################################################
function syntax()
{
	echo "syntax $(basename $BASH_SOURCE) locationID storeID [EXECUTE]"
	exit 1
}
########################################################################################################
#
########################################################################################################
function timestamp()
{
	echo "$(date +%Y/%m/%d-%H:%M:%S)"
}
########################################################################################################
#
########################################################################################################
function firefoxcheck()
{
	########################################################################################################
	#	Firefox	
	#	curl check POSIX
	#	locationID, storeID, [EXECUTE]
	#	con variabili
	#	ITA
	########################################################################################################
	LOCATIONID=$1
	STOREID=$2
	BEARERID=$3
	#
	LOCATIONID=12890
	STOREID=1211
	BEARERID=ed01e2e071ddbda38ea5a85f43ae547360bd0bbf
	#
	TEMP_ERR=output/error.json.temp
	TEMP_CHK=output/check.json.temp
	OUT_ERR=output/error.json
	OUT_CHK=output/check.json
	########################################################################################################
	#	log parameters
	########################################################################################################
	{
	echo -e "########################################################################################################"
	echo -e "$(timestamp)\tlocationID:$LOCATIONID\tstoreID:$STOREID\tbearerID:$BEARERID"
	echo -e "########################################################################################################"
	} | tee -a $OUT_ERR >>$OUT_CHK 
	#read
	########################################################################################################
	#	print command
	########################################################################################################
	[ -v DEBUG ] && {
		echo "$DEBUG \\"
	}
	echo "curl 'https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP' \ "
	echo "-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \ "
	echo "-H 'Accept: application/json, text/plain, */*' \ "
	echo "-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \ "
	echo "-H 'Referer: https://www.supermercato24.it/s' \ "
	echo "-H 'Authorization: Bearer $BEARERID' \ "
	echo "-H 'X-S24-Client: website/2.0.0-alpha.1' \ "
	echo "-H 'X-S24-Country: ITA' \ "
	echo "-H 'Origin: https://www.supermercato24.it' \ "
	echo "-H 'Connection: keep-alive' \ "
	echo "-H 'Pragma: no-cache' \ "
	echo "-H 'Cache-Control: no-cache' \ "
	echo "-w '\nHTTP_STATUS: %{http_code}\n' \ "
	echo "--compressed \ "
	echo "	2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)"
	#
	echo "########################################################################################################"
	########################################################################################################
	#	run command
	########################################################################################################
	#OUTPUT="$(
	$DEBUG \
	curl "https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP" \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	-H 'Accept: application/json, text/plain, */*' \
	-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \
	-H 'Referer: https://www.supermercato24.it/s' \
	-H "Authorization: Bearer $BEARERID" \
	-H 'X-S24-Client: website/2.0.0-alpha.1' \
	-H 'X-S24-Country: ITA' \
	-H 'Origin: https://www.supermercato24.it' \
	-H 'Connection: keep-alive' \
	-H 'Pragma: no-cache' \
	-H 'Cache-Control: no-cache' \
	-w '\nHTTP_STATUS: %{http_code}\n' \
	--compressed \
	2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)
	#)"
	########################################################################################################
	#	get returncode and json
	########################################################################################################
	RETURNCODE=$?
	echo -n "curl retcode: $RETURNCODE, curl status: "
	[ $RETURNCODE ] && echo "ok" || echo "ko"
	#
	########################################################################################################
	#	update log files
	########################################################################################################
	cat $TEMP_CHK >> $OUT_CHK
	cat $TEMP_ERR >> $OUT_ERR
	########################################################################################################
	#	extract data
	########################################################################################################
	IFS=': ' read -r _ STATUSCODE < <(tail -n1 $TEMP_CHK)
	JSON="$(head -n-1 $TEMP_CHK)"
	echo "########################################################################################################"
	echo "STATUSCODE: $STATUSCODE"
	echo "JSON      : $JSON"
	echo "########################################################################################################"
	if which jq
	then
		echo "trovato jq"
	elif which python3
	then
		echo "trovato python3"
	elif which python
	then
		echo "trovato python"
	else
		echo "nessun tool trovato"
		return
	fi
	if [ $STATUSCODE -eq 404 ]
	then
		echo "NON CI SONO DISPONIBILITA'"
		return
	elif [ $STATUSCODE -eq 200 ]
	then
		echo "******************************************"
		echo "*                                        *"
		echo "*        PROBABILE DISPONIBILITA'        *"
		echo "*                                        *"
		echo "******************************************"
	else
		:
	fi
	########################################################################################################
	#	remove temp files
	########################################################################################################
	rm $TEMP_CHK $TEMP_ERR
}
########################################################################################################
#
#	MAIN
#
########################################################################################################

########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 3 ] || syntax

echo "########################################################################################################"
echo "script      : $(basename $BASH_SOURCE)"
echo "parameters  : $#"
for arg
do
	echo "parameter   : $arg"
done
echo "########################################################################################################"

firefoxcheck "$1" "$2" "$3"




