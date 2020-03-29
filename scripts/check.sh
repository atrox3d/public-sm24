#!/bin/bash
########################################################################################################
# check parameters or exit
########################################################################################################
[ $# -ge 1 ] || {
	echo "syntax $(basename $BASH_SOURCE) email"
	exit 1
}
EMAIL="$1"
################################################################################
STARTPATH="$(pwd)"
SCRIPTPATH="$(dirname $(realpath $0))"
cd "$SCRIPTPATH"
SCRIPTNAME="$(basename $0)"
INCLUDE="${SCRIPTPATH}/functions.include"
################################################################################
#
#	load include
#
################################################################################
. "$INCLUDE" || { echo "ERROR|cannot source $INCLUDE"; exit 1; }
################################################################################
CURDIR="$(pwd)"
DATADIR="${SCRIPTPATH}/../data/$EMAIL"
LOGDIR="${SCRIPTPATH}/log"
OUTDIR="${SCRIPTPATH}/output"
TIMESERIAL="$(timeserial)"
LOGFILE="${LOGDIR}/${EMAIL}.${TIMESERIAL}.log"
################################################################################
#
#
#
#	EXEC
#
#
#
################################################################################
exec &> >(tee -a "$LOGFILE")
#echo "This will be logged to the file and to the screen"
#exec >> "$LOGFILE"
#exec 2>&1
CREDENTIALS="${DATADIR}/credentials"
STORES="${DATADIR}/stores"
########################################################################################################
#
# output variables
#
########################################################################################################
echo "INFO| STARTPATH     : $STARTPATH"
echo "INFO| SCRIPTPATH    : $SCRIPTPATH"
echo "INFO| SCRIPTNAME    : $SCRIPTNAME"
echo "INFO| INCLUDE       : $INCLUDE"
echo "INFO| CURDIR        : $CURDIR"
echo "INFO| DATADIR       : $DATADIR"
echo "INFO| LOGDIR        : $LOGDIR"
echo "INFO| OUTDIR        : $OUTDIR"
echo "INFO| LOGFILE       : $LOGFILE"
echo "INFO| MAIL       : $EMAIL"
echo "INFO| CREDENTIALS   : $CREDENTIALS"
echo "INFO| STORES        : $STORES"
########################################################################################################
#
# check execution parameters
#
########################################################################################################
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
	./firefox.check.sh \
			"$LOCATIONID" \
			"$STOREID" \
			"$BEARERID" \
			"$STORENAME" \
			"$STOREADDRESS" \
			"$EMAIL" \
			"$TIMESERIAL" \
			EXECUTE
	SLEEPTIME=5
	echo "INFO| SLEEP $SLEEPTIME"
	sleep 5
done < "$STORES"

