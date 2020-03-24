#!/bin/bash

#while read -r a b c; do echo "$a, $b, $c";done < credentials

########################################################################################################
#
#	starts always in debug unless $3 == EXECUTE
#
########################################################################################################
DEBUG="echo "
[ $# -gt 2 ] && {
	[ $3 == EXECUTE ] && {
		unset DEBUG
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
	
	LOCATIONID=12890
	STOREID=1211
	BEARER=ed01e2e071ddbda38ea5a85f43ae547360bd0bbf
	
	ACOMMAND=()
	[ -v DEBUG ] && {
		ACOMMAND+=("$DEBUG")
	}
	ACOMMAND+=("curl 'https://api.supermercato24.it/sm/api/v3/locations/'$LOCATIONID'/stores/'$STOREID'/availability?funnel=POSTAL_CODE_POPUP' ")
	ACOMMAND+=("-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' ")
	#ACOMMAND+=("-H 'Accept: application/json, text/plain, */*' ")
	#ACOMMAND+=("-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' ")
	#ACOMMAND+=("-H 'Referer: https://www.supermercato24.it/s' ")
	#ACOMMAND+=("-H 'Authorization: Bearer $BEARER' ")
	#ACOMMAND+=("-H 'X-S24-Client: website/2.0.0-alpha.1' ")
	#ACOMMAND+=("-H 'X-S24-Country: ITA' ")
	#ACOMMAND+=("-H 'Origin: https://www.supermercato24.it' ")
	#ACOMMAND+=("-H 'Connection: keep-alive' ")
	#ACOMMAND+=("-H 'Pragma: no-cache' ")
	#ACOMMAND+=("-H 'Cache-Control: no-cache' ")
	#ACOMMAND+=("--compressed ")
	#ACOMMAND+=("-w \"\nHTTP_STATUS: %{http_code}\n\" ")

	length=${#ACOMMAND[@]}
	current=0
	echo $length
	for each in "${ACOMMAND[@]}"
	do
		current=$((++current))
		[ $current -eq $length ] && {
			echo "$each"
		} || {
			echo "$each \\"
		}
	done
	echo "########################################################################################################"
	COMMAND="$(IFS= ; echo "${ACOMMAND[@]}")"
	echo "$COMMAND"
	echo "########################################################################################################"
	$COMMAND
	echo "########################################################################################################"
	return
	
	#
	#echo -e "########################################################################################################" >> output/token.json
	#echo -e "$(timestamp)\t$LOGIN_MAIL\t$LOGIN_PASSWORD" >> output/token.json
	#echo -e "########################################################################################################" >> output/token.json
	#
	#curl 'https://api.supermercato24.it/sm/api/v3/locations/12890/stores/1211/availability?funnel=POSTAL_CODE_POPUP' \
	echo "########################################################################################################"
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
	--compressed 
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
[ $# -ge 2 ] || syntax

echo "########################################################################################################"
echo "script      : $(basename $BASH_SOURCE)"
echo "parameters  : $#"
for arg
do
	echo "parameter   : $arg"
done
echo "########################################################################################################"

firefoxcheck "$1" "$2"



