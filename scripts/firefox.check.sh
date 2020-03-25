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
	#LOGIN_MAIL="$1"
	#LOGIN_PASSWORD="$2"
	LOCATIONID=$1
	STOREID=$2
	BEARERID=$3
	
	LOCATIONID=12890
	STOREID=1211
	BEARERID=ed01e2e071ddbda38ea5a85f43ae547360bd0bbf
	
	[ -v DEBUG ] && {
		echo "$DEBUG \\"
	}
	echo "curl 'https://api.supermercato24.it/sm/api/v3/locations/'$LOCATIONID'/stores/'$STOREID'/availability?funnel=POSTAL_CODE_POPUP' \ "
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
	echo "-H 'Cache-Control: no-cache'\ "
	echo "-w \"\nHTTP_STATUS: %{http_code}\n\" \ "
	echo "--compressed "
	#
	#echo -e "########################################################################################################" >> output/token.json
	#echo -e "$(timestamp)\t$LOGIN_MAIL\t$LOGIN_PASSWORD" >> output/token.json
	#echo -e "########################################################################################################" >> output/token.json
	#
	#curl 'https://api.supermercato24.it/sm/api/v3/locations/12890/stores/1211/availability?funnel=POSTAL_CODE_POPUP' \
	echo "########################################################################################################"
	OUTPUT="$(
	$DEBUG \
	curl 'https://api.supermercato24.it/sm/api/v3/locations/'$LOCATIONID'/stores/'$STOREID'/availability?funnel=POSTAL_CODE_POPUP' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	-H 'Accept: application/json, text/plain, */*' \
	-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \
	-H 'Referer: https://www.supermercato24.it/s' \
	-H 'Authorization: Bearer ed01e2e071ddbda38ea5a85f43ae547360bd0bbf' \
	-H 'X-S24-Client: website/2.0.0-alpha.1' \
	-H 'X-S24-Country: ITA' \
	-H 'Origin: https://www.supermercato24.it' \
	-H 'Connection: keep-alive' \
	-H 'Pragma: no-cache' \
	-H 'Cache-Control: no-cache'\
	-w "\nHTTP_STATUS: %{http_code}\n" \
	--compressed 2>&1
	)"
	RETURNCODE=$?
	
	echo "output: $OUTPUT"
	[ $RETURNCODE ] && echo "ok" || echo "ko"
	echo "########################################################################################################"
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




