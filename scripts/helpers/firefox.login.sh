#!/bin/bash

#while read -r a b c; do echo "$a, $b, $c";done < credentials
################################################################################
#                                                                              #
#	START                                                                      #
#                                                                              #
################################################################################
STARTPATH="$(pwd)"
#SCRIPTPATH="$(dirname $(realpath $0))"
SCRIPTPATH="$(dirname $(readlink -f $0))"
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
#
#	starts always in debug unless $3 == EXECUTE
#
########################################################################################################
DEBUG=echo
[ $# -gt 2 ] && {
	[ $3 == EXECUTE ] && {
		DEBUG=
	}
}
########################################################################################################
#
########################################################################################################
#function syntax()
#{
#	echo "syntax $(basename $BASH_SOURCE) user password [EXECUTE]"
#	exit 1
#}
########################################################################################################
#
########################################################################################################
#function timestamp()
#{
#	echo "$(date +%Y/%m/%d-%H:%M:%S)"
#}
########################################################################################################
#
########################################################################################################
function firefoxlogin()
{
	########################################################################################################
	#	Firefox	
	#	curl login POSIX
	#	user, password, [EXECUTE]
	#	senza coookies
	#	con variabili
	#	ITA
	########################################################################################################
	LOGIN_MAIL="$1"
	LOGIN_PASSWORD="$2"
	#
	echo -e "########################################################################################################" >> output/token.json
	echo -e "$(timestamp)\t$LOGIN_MAIL\t$LOGIN_PASSWORD" >> output/token.json
	echo -e "########################################################################################################" >> output/token.json
	#
	echo "executing:"
	echo "$DEBUG \                                                                                         "
	echo "curl 'https://www.supermercato24.it/user/api/v1/local/signin?' \                                 "
	echo "-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \ "
	echo "-H 'Accept: application/json, text/plain, */*' \                                                 "
	echo "-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \                                      "
	echo "-H 'Referer: https://www.supermercato24.it/' \                                                   "
	echo "-H 'X-Sm24: website/7.1.11' \                                                                    "
	echo "-H 'Content-Type: application/json;charset=utf-8' \                                              "
	echo "-H 'Origin: https://www.supermercato24.it' \                                                     "
	echo "-H 'Connection: keep-alive' \                                                                    "
	echo "--data '{\"email\":\"$LOGIN_MAIL\",\"password\":\"$LOGIN_PASSWORD\"}' \                          "
	echo "-w \"\nHTTP_STATUS: %{http_code}\n\" \ "
	echo "--compressed | tee -a output/token.json"
	#
	echo "########################################################################################################"
	$DEBUG \
	curl 'https://www.supermercato24.it/user/api/v1/local/signin?' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0' \
	-H 'Accept: application/json, text/plain, */*' \
	-H 'Accept-Language: it-IT,it;q=0.8,en-US;q=0.5,en;q=0.3' \
	-H 'Referer: https://www.supermercato24.it/' \
	-H 'X-Sm24: website/7.1.11' \
	-H 'Content-Type: application/json;charset=utf-8' \
	-H 'Origin: https://www.supermercato24.it' \
	-H 'Connection: keep-alive' \
	--data '{"email":"'$LOGIN_MAIL'","password":"'$LOGIN_PASSWORD'"}' \
	-w "\nHTTP_STATUS: %{http_code}\n" \
	--compressed | tee -a output/token.json
	echo >> output/token.json
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
checkparameters $# 1 "$(basename $BASH_SOURCE) user password [EXECUTE]" || exit 1

echo "########################################################################################################"
echo "script      : $(basename $BASH_SOURCE)"
echo "parameters  : $#"
for arg
do
	echo "parameter   : $arg"
done
echo "########################################################################################################"

firefoxlogin "$1" "$2"




