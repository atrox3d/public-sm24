#!/bin/bash
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


function formail()
{
	[ $# -ge 1 ] || {
		error "syntax formail functionname args"
		return 1
	}

	#SCRIPTPATH="$(dirname $(realpath $0))"
	DATAFOLDER="${SCRIPTPATH}/../data"
	echo "DATAFOLDER : $DATAFOLDER"
	#echo "content   : $(ls $DATAFOLDER)"
	#for mail in ../data/*/
	for mail in $(ls $DATAFOLDER)
	do
		#mail="$(basename $mail)"
		#storesfile="../data/${mail}/stores"
		#echo "$(timestamp)|mail:$mail|stores file: $storesfile"
		#./createstores.sh "$mail" > "$storesfile"
		#echo $mail
		info "$@" "$mail"
		$@ $mail
	done
}

function echomail() { echo $mail; }

if [ "$(basename $BASH_SOURCE)" == "$(basename $0)" ]
then

	[ $# -ge 1 ] || {
		fatal "syntax formail.sh script args"
		exit 1
	}

	formail $@
fi
