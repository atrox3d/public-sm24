#!/bin/bash
#echo $(realpath $0)
#echo $(readlink -f $0)
#echo $(realpath $BASH_SOURCE)
#echo $(readlink -f $BASH_SOURCE)


function formail()
{
	[ $# -ge 1 ] || {
		echo "ERROR| syntax formail functionname args"
		return 1
	}

	SCRIPTPATH="$(dirname $(realpath $0))"
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
		$*
	done
}

function echomail() { echo $mail; }

if [ "$(basename $BASH_SOURCE)" == "$(basename $0)" ]
then
	formail echomail
fi
