#!/bin/bash
################################################################################
#
#	load include
#
################################################################################
. functions.include
########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 1 ] || {
	echo "syntax $(basename $BASH_SOURCE) email"
	exit 1
}

EMAIL="$1"
DATADIR=../data/$EMAIL
CREDENTIALS="${DATADIR}/credentials"
STORES="${DATADIR}/stores"
########################################################################################################
#
# check execution parameters
#
########################################################################################################
echo "INFO| MAIL       : $EMAIL"
#
[ -d  "$DATADIR" ] || {
	echo "ERROR| path $DATADIR not found"
	echo "ERROR| exiting"
	exit 2
}
echo "INFO| DATADIR    : $DATADIR    : OK"
#
[ -f  "$CREDENTIALS" ] || {
	echo "ERROR| file $CREDENTIALS not found"
	echo "ERROR| exiting"
	exit 3
}
echo "INFO| CREDENTIALS: $CREDENTIALS: OK"
#
[ -f  "$STORES" ] || {
	echo "ERROR| file $STORES not found"
	echo "ERROR| exiting"
	exit 4
}
echo "INFO| STORES     : $STORES      : OK"
########################################################################################################
#
# parse credentials
#
########################################################################################################
#
read -r _email _password BEARERID < "$CREDENTIALS"
echo "INFO| BEARERID   : $BEARERID"
#
while read -r LOCATIONID STOREID STORENAME STOREADDRESS
do
	echo "INFO| LOCATIONID  : $LOCATIONID"
	echo "INFO| STOREID     : $STOREID"
	echo "INFO| STORENAME   : $STORENAME"
	echo "INFO| STOREADDRESS: $STOREADDRESS"
	echo "INFO| ./firefox.check.sh $LOCATIONID $STOREID $BEARERID $STORENAME $STOREADDRESS EXECUTE"
	./firefox.check.sh "$LOCATIONID" "$STOREID" "$BEARERID" "$STORENAME" "$STOREADDRESS" EXECUTE
	SLEEPTIME=5
	echo "INFO| SLEEP $SLEEPTIME"
	sleep 5
done < "$STORES"




exit
for mail in ../data/*/
do
	mail="$(basename $mail)"
	storesfile="../data/${mail}/stores"
	echo "$(timestamp)|mail:$mail|stores file: $storesfile"
	./createstores.sh "$mail" > "$storesfile"
done

