#!/bin/bash
################################################################################
#                                                                              #
################################################################################
function syntax()
{
	echo "syntax $(basename $BASH_SOURCE) locationID storeID bearerID storeName storeAddress TIMSERIAL [EXECUTE]"
	exit 1
}
################################################################################
#                                                                              #
################################################################################
function firefoxcheck()
{
	################################################################################
	#	Firefox	                                                                   #
	#	curl check POSIX                                                           #
	#		locationID                                                             #
	#		storeID                                                                #
	#		bearerID                                                               #
	#		storeName                                                              #
	#		storeAddress                                                           #
	#		mailaddress                                                            #
	#		[EXECUTE]                                                              #
	#	con variabili                                                              #
	#	ITA                                                                        #
	################################################################################
	LOCATIONID="$1"
	STOREID="$2"
	BEARERID="$3"
	STORENAME="$4"
	STOREADDRESS="$5"
	MAILADDRESS="$6"
	TIMESERIAL="$7"
	EXECUTE=$8
	################################################################################
	#	forzo bro mail                                                             #
	################################################################################
	[ "$MAILADDRESS" == "***REMOVED***" ] && {
		MAILLOG="$MAILADDRESS"
		MAILADDRESS=***REMOVED***
	} || {
		MAILLOG="$MAILADDRESS"
	}
	################################################################################
	#	dump variabili                                                             #
	################################################################################
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
	TEMP_ERR=output/"${MAILLOG}"."${TIMESERIAL}".error.json.temp
	TEMP_CHK=output/"${MAILLOG}"."${TIMESERIAL}".check.json.temp
	OUT_ERR=output/"${MAILLOG}"."${TIMESERIAL}".error.json
	OUT_CHK=output/"${MAILLOG}"."${TIMESERIAL}".check.json
	OUT_JSON=output/"${MAILLOG}"."$STORENAME"."${TIMESERIAL}".json
	################################################################################
	#	log parameters                                                             #
	################################################################################
	#echo "INFO| creazione $OUT_ERR"
	#echo "INFO| creazione $OUT_CHK"
	#{
	#echo -e "########################################################################################################"
	#echo -e "$(timestamp)\tlocationID   : $LOCATIONID"
	#echo -e "$(timestamp)\tstoreID      : $STOREID"
	#echo -e "$(timestamp)\tbearerID     : $BEARERID"
	#echo -e "$(timestamp)\tstoreName    : $STORENAME"
	#echo -e "$(timestamp)\tstoreAddress : $STOREADDRESS"
	#echo -e "$(timestamp)\tmailAddress  : $MAILADDRESS"
	#echo -e "########################################################################################################"
	#} | tee -a $OUT_ERR >>$OUT_CHK 
	#read
	################################################################################
	#	print command                                                              #
	################################################################################
	#[ -v DEBUG ] && {
	isDEBUG && {
		echo "$DEBUG \\"
	}
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
	################################################################################
	#	run command                                                                #
	################################################################################
	echo "INFO| creazione $TEMP_ERR"
	echo "INFO| creazione $TEMP_CHK"
	echo "INFO| creazione $OUT_JSON"
	$DEBUG \
	curl "https://api.supermercato24.it/sm/api/v3/locations/$LOCATIONID/stores/$STOREID/availability?funnel=POSTAL_CODE_POPUP" \
	-H 'Connection: keep-alive' \
	-H 'X-S24-Country: ITA' \
	-H 'X-S24-Client: website/2.0.0-alpha.1' \
	-H 'Origin: https://www.supermercato24.it' \
	-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \
	-H "Authorization: Bearer $BEARERID" \
	-H 'Accept: application/json, text/plain, */*' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	-H 'Referer: https://www.supermercato24.it/s' \
	-w '\nHTTP_STATUS: %{http_code}\n' \
	--compressed \
	2> >(tee -a $TEMP_ERR) 1> >(tee -a $TEMP_CHK)
	#)"
	################################################################################
	#	get returncode and json                                                    #
	################################################################################
	RETURNCODE=$?
	echo -n "curl retcode: $RETURNCODE, curl status: "
	[ $RETURNCODE ] && echo "ok" || echo "ko"
	#
	################################################################################
	#	update log files                                                           #
	################################################################################
	#echo "INFO| update $OUT_CHK"
	#echo "INFO| update $OUT_ERR"
	#cat $TEMP_CHK >> $OUT_CHK
	#cat $TEMP_ERR >> $OUT_ERR
	################################################################################
	#	extract STATUSCODE                                                         #
	################################################################################
	echo "INFO| estrazione STATUS_CODE"
	IFS=': ' read -r _ STATUSCODE < <(tail -n1 $TEMP_CHK)
	################################################################################
	#	extract JSON                                                               #
	################################################################################
	echo "INFO| estrazione JSON"
	JSON="$(head -n-1 $TEMP_CHK)"
	################################################################################
	#	DEBUG force status code                                                    #
	################################################################################
	#[ -v DEBUG ] && {
	isDEBUG && {
		echo "DEBUG| forzatura JSON, STATUSCODE"
		STATUSCODE=200
		JSON='{"DEBUG": true, "STATUSCODE":200}'
	}
	echo "########################################################################################################"
	echo "STATUSCODE: $STATUSCODE"
	echo "JSON      : $JSON"
	echo "########################################################################################################"
	################################################################################
	#                                                                              #
	#                                                                              #
	#                                                                              #
	#	STATUSCODE evaluation                                                      #
	#                                                                              #
	#                                                                              #
	#                                                                              #
	################################################################################
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
		#echo ./mailer.sh "$MAILADDRESS" "$MAILADDRESS - SM24 - UNAUTHORIZED - $STORENAME" "ERRORE 401 su $STORENAME"
		#./mailer.sh "$MAILADDRESS" "$MAILADDRESS - SM24 - UNAUTHORIZED - $STORENAME" "ERRORE 401 su $STORENAME"
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
		#./mailer.sh "$MAILADDRESS" "$MAILADDRESS - NO SLOT DISPONIBILE PER $STORENAME" "NESSUNO SLOT PER $STORENAME - $STOREADDRESS"
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
	else
		echo "WARNING | unknown status: $STATUSCODE" >> $OUT_CHK
	fi
	################################################################################
	#	update json                                                                #
	################################################################################
	OUT_JSON=output/"${MAILLOG}"."$STORENAME"."$STATUSCODE"."${TIMESERIAL}".json
	echo "INFO| update $OUT_JSON"
	echo "$JSON" > "$OUT_JSON"
	################################################################################
	#	STATUSCODE 200                                                             #
	################################################################################
	#if [ $STATUSCODE -eq 200 ]
	#then
	#	echo ./mailer.sh \
	#			"$MAILADDRESS" \
	#			"$MAILADDRESS - SM24 - $STORENAME" \
	#			"TROVATO SLOT PER $STORENAME - $STOREADDRESS"
	#	#
	#	./mailer.sh \
	#		"$MAILADDRESS" \
	#		"$MAILADDRESS - SM24 - $STORENAME" \
	#		"TROVATO SLOT PER $STORENAME - $STOREADDRESS"
	#	#
	#	if PARSER="$(getJSONparser)"
	#	then
	#		echo "found JSON parser : $PARSER"
	#	else
	#		echo "no JSON parser"
	#	fi
	#fi
	################################################################################
	#	remove temp files                                                          #
	################################################################################
	rm $TEMP_CHK $TEMP_ERR
	[ $STATUSCODE -eq 200 ] && return 0 || return 1
}
################################################################################
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#	                               MAIN                                        #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
#                                                                              #
################################################################################
#                                                                              #
#	$(basename $BASH_SOURCE)                                                   #
#		locationID                                                             #
#		storeID                                                                #
#		bearerID                                                               #
#		storeName                                                              #
#		storeAddress                                                           #
#		mailaddress                                                            #
#		[EXECUTE]                                                              #
#                                                                              #
################################################################################
#                                                                              #
#	load include                                                               #
#                                                                              #
################################################################################
. functions.include
################################################################################
# check parameters or exit                                                     #
################################################################################
MINPARAMS=7
DEBUGPARAM=$((MINPARAMS+1))

checkparameters $# $MINPARAMS "$(basename $BASH_SOURCE) locationID storeID bearerID storeName storeAddress mailAddress timeSerial [EXECUTE]"
################################################################################
#                                                                              #
#	starts always in debug unless $3 == EXECUTE                                #
#                                                                              #
################################################################################
setDEBUG ON
DEBUG=echo
#[ $# -gt $MINPARAMS ] && {
[ "${!DEBUGPARAM}" == "EXECUTE" ] && {
	setDEBUG OFF
	unset DEBUG
}
#}
echo "INFO| DEBUG=$DEBUG"
echo "########################################################################################################"
echo "script      : $(basename $BASH_SOURCE)"
echo "parameters  : $#"
for arg
do
	echo "parameter   : $arg"
done
echo "########################################################################################################"
firefoxcheck "$@"





