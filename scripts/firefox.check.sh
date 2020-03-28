#!/bin/bash
################################################################################
#
#	$(basename $BASH_SOURCE) locationID storeID bearerID storeName storeAddress [EXECUTE]
#
################################################################################
#
#	load include
#
################################################################################
. functions.include
########################################################################################################
#
########################################################################################################
function syntax()
{
	echo "syntax $(basename $BASH_SOURCE) locationID storeID bearerID mailaddress [EXECUTE]"
	exit 1
}
########################################################################################################
#
########################################################################################################
function firefoxcheck()
{
	########################################################################################################
	#	Firefox	
	#	curl check POSIX
	#	locationID, storeID, bearerID, [EXECUTE]
	#	con variabili
	#	ITA
	########################################################################################################
	LOCATIONID="$1"
	STOREID="$2"
	BEARERID="$3"
	STORENAME="$4"
	STOREADDRESS="$5"
	MAILADDRESS="$6"
	EXECUTE=$7
	# forzo bro
	[ "$MAILADDRESS" == "***REMOVED***" ] && MAILADDRESS=adrianolombardo@***REMOVED***
	#
	echo "INFO| LOCATIONID  : $LOCATIONID"
	echo "INFO| STOREID     : $STOREID"
	echo "INFO| STORENAME   : $STORENAME"
	echo "INFO| BEARERID    : $BEARERID"
	echo "INFO| STOREADDRESS: $STOREADDRESS"
	echo "INFO| MAILADDRESS : $MAILADDRESS"
	echo "INFO| EXECUTE     : $EXECUTE"
	echo "INFO| DEBUG       : $DEBUG"
	echo "########################################################################################################"
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
	echo -e "$(timestamp)\tlocationID   : $LOCATIONID"
	echo -e "$(timestamp)\tstoreID      : $STOREID"
	echo -e "$(timestamp)\tbearerID     : $BEARERID"
	echo -e "$(timestamp)\tstoreName    : $STORENAME"
	echo -e "$(timestamp)\tstoreAddress : $STOREADDRESS"
	echo -e "$(timestamp)\tmailAddress  : $MAILADDRESS"
	echo -e "########################################################################################################"
	} | tee -a $OUT_ERR >>$OUT_CHK 
	#read
	########################################################################################################
	#	print command
	########################################################################################################
	[ -v DEBUG ] && {
		echo "$DEBUG \\"
	}
	#echo "curl 'https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP' \ "
	#echo "-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \ "
	#echo "-H 'Accept: application/json, text/plain, */*' \ "
	#echo "-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \ "
	#echo "-H 'Referer: https://www.supermercato24.it/s' \ "
	#echo "-H 'Authorization: Bearer $BEARERID' \ "
	#echo "-H 'X-S24-Client: website/2.0.0-alpha.1' \ "
	#echo "-H 'X-S24-Country: ITA' \ "
	#echo "-H 'Origin: https://www.supermercato24.it' \ "
	#echo "-H 'Connection: keep-alive' \ "
	#echo "-H 'Pragma: no-cache' \ "
	#echo "-H 'Cache-Control: no-cache' \ "
	#echo "-w '\nHTTP_STATUS: %{http_code}\n' \ "
	#echo "--compressed \ "
	#echo "	2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)"
	#
	echo "curl 'https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP' \ "
	echo "-H 'Connection: keep-alive' \                                                                                      "
	echo "-H 'X-S24-Country: ITA' \                                                                                          "
	echo "-H 'X-S24-Client: website/2.0.0-alpha.1' \                                                                         "
	echo "-H 'Origin: https://www.supermercato24.it' \                                                                       "
	echo "-H 'Authorization: Bearer $BEARERID' \                                              "
	echo "-H 'Accept: application/json, text/plain, */*' \                                                                   "
	echo "-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \                   "
	echo "-H 'Referer: https://www.supermercato24.it/s' \                                                                    "
	echo "--compressed \                                                                                                     "
	echo "-w '\nHTTP_STATUS: %{http_code}\n' \                                                                                 "
	echo "	2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)"
	#
	echo "########################################################################################################"
	########################################################################################################
	#	run command
	########################################################################################################
	#OUTPUT="$(
	# $DEBUG \
	# curl "https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP" \
	# -H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	# -H 'Accept: application/json, text/plain, */*' \
	# -H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \
	# -H 'Referer: https://www.supermercato24.it/s' \
	# -H "Authorization: Bearer $BEARERID" \
	# -H 'X-S24-Client: website/2.0.0-alpha.1' \
	# -H 'X-S24-Country: ITA' \
	# -H 'Origin: https://www.supermercato24.it' \
	# -H 'Connection: keep-alive' \
	# -H 'Pragma: no-cache' \
	# -H 'Cache-Control: no-cache' \
	# -w '\nHTTP_STATUS: %{http_code}\n' \
	# --compressed \
	# 2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)
	$DEBUG \
	curl "https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP" \
	-H 'Connection: keep-alive' \
	-H 'X-S24-Country: ITA' \
	-H 'X-S24-Client: website/2.0.0-alpha.1' \
	-H 'Origin: https://www.supermercato24.it' \
	-H "Authorization: Bearer $BEARERID" \
	-H 'Accept: application/json, text/plain, */*' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	-H 'Referer: https://www.supermercato24.it/s' \
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
	[ -v DEBUG ] && {
		STATUSCODE=200
		JSON='{"DEBUG": true, "STATUSCODE":200}'
	}

	echo "########################################################################################################"
	echo "STATUSCODE: $STATUSCODE"
	echo "JSON      : $JSON"
	echo "########################################################################################################"

	if  [ "$STATUSCODE" -eq 401 ]
	then
		echo "########################################################################################################"
		echo "# $MAILADDRESS"
		echo "########################################################################################################"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                        !!!!! UNAUTNORIZED !!!                                        #"
		echo "#                                        !!!!! UNAUTNORIZED !!!                                        #"
		echo "#                                        !!!!! UNAUTNORIZED !!!                                        #"
		echo "#                                        !!!!! UNAUTNORIZED !!!                                        #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "########################################################################################################"
		exit 401
	elif [ "$STATUSCODE" -eq 404 ]
	then
		#echo "$STORENAME"
		#echo "$STOREADDRESS"
		echo "########################################################################################################"
		echo "# $MAILADDRESS"
		echo "########################################################################################################"
		echo "#                                        NESSUNA DISPONIBILITA'                                        #"
		echo "#                                                                                                      #"
		echo "					$STORENAME"
		echo "					$STOREADDRESS"
		echo "########################################################################################################"
		./mailer.sh "$MAILADDRESS" "$MAILADDRESS - NO SLOT DISPONIBILE PER $STORENAME" "NESSUNO SLOT PER $STORENAME - $STOREADDRESS"
	elif [ $STATUSCODE -eq 200 ]
	then
		#echo "$STORENAME"
		#echo "$STOREADDRESS"
		echo "########################################################################################################"
		echo "# $MAILADDRESS"
		echo "########################################################################################################"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "#                                        PROBABILE DISPONIBILITA'                                      #"
		echo "#                                                                                                      #"
		echo "					$STORENAME"
		echo "					$STOREADDRESS"
		echo "#                                                                                                      #"
		echo "#                                                                                                      #"
		echo "########################################################################################################"
		echo "# INVIO MAIL A : $MAILADDRESS"
		echo "########################################################################################################"
		echo ./mailer.sh "$MAILADDRESS" "$MAILADDRESS - SLOT DISPONIBILE PER $STORENAME" "TROVATO SLOT PER $STORENAME - $STOREADDRESS"
		if PARSER="$(getJSONparser)"
		then
			echo "found JSON parser : $PARSER"
		else
			echo "no JSON parser"
		fi
	else
		echo "WARNING | unknown status: $STATUSCODE" >> $OUT_CHK
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
#
#	$(basename $BASH_SOURCE) locationID storeID bearerID storeName storeAddress mailaddress [EXECUTE]
#
########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 6 ] || syntax
########################################################################################################
#
#	starts always in debug unless $3 == EXECUTE
#
########################################################################################################
DEBUG=echo
[ $# -gt 6 ] && {
	[ $7 == EXECUTE ] && {
		unset DEBUG
	}
}

echo "########################################################################################################"
echo "script      : $(basename $BASH_SOURCE)"
echo "parameters  : $#"
for arg
do
	echo "parameter   : $arg"
done
echo "########################################################################################################"

firefoxcheck "$1" "$2" "$3" "$4" "$5" "$6" "$7"




