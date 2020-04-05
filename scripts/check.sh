#!/bin/bash
################################################################################
#                                                                              #
#	START                                                                      #
#                                                                              #
################################################################################
STARTPATH="$(pwd)"
SCRIPTPATH="$(dirname $(realpath $0))"
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
################################################################################
#                                                                              #
# check parameters or exit                                                     #
#                                                                              #
################################################################################
#[ $# -ge 1 ] || {
#	echo "syntax $(basename $BASH_SOURCE) email"
#	exit 1
#}
checkparameters $# 1 "$(basename $BASH_SOURCE) email" || exit 1
EMAIL="$1"
################################################################################
#                                                                              #
#	SET VARIABLES                                                              #
#                                                                              #
################################################################################
CURDIR="$(pwd)"
DATADIR="${SCRIPTPATH}/../data/$EMAIL"
LOGDIR="${SCRIPTPATH}/log"
OUTDIR="${SCRIPTPATH}/output"
TIMESERIAL="$(timeserial)"
LOGFILE="${LOGDIR}/${EMAIL}.${TIMESERIAL}.log"
################################################################################
#                                                                              #
#                                                                              #
#                                                                              #
#	EXEC                                                                       #
#                                                                              #
#	echo "This will be logged to the file and to the screen"                   #
#	exec >> "$LOGFILE"                                                         #
#	exec 2>&1                                                                  #
#                                                                              #
#                                                                              #
################################################################################
info "########################################################################################################"
info "redirecting to STDOUT and $LOGFILE"
info "########################################################################################################"
exec &> >(tee -a "$LOGFILE")
CREDENTIALS="${DATADIR}/credentials"
STORES="${DATADIR}/stores"
################################################################################
#                                                                              #
# output variables                                                             #
#                                                                              #
################################################################################
info "STARTPATH     : $STARTPATH"
info "SCRIPTPATH    : $SCRIPTPATH"
info "SCRIPTNAME    : $SCRIPTNAME"
info "INCLUDE       : $INCLUDE"
info "CURDIR        : $CURDIR"
info "DATADIR       : $DATADIR"
info "LOGDIR        : $LOGDIR"
info "OUTDIR        : $OUTDIR"
info "LOGFILE       : $LOGFILE"
info "MAIL          : $EMAIL"
info "CREDENTIALS   : $CREDENTIALS"
info "STORES        : $STORES"
################################################################################
#                                                                              #
# check execution parameters                                                   #
#                                                                              #
################################################################################
#
[ -d  "$DATADIR" ] || {
	fatal "path $DATADIR not found"
	fatal "exiting"
	exit 2
}
echo "INFO| DATADIR    : $DATADIR    : OK"
#
[ -f  "$CREDENTIALS" ] || {
	fatal "file $CREDENTIALS not found"
	fatal "exiting"
	exit 3
}
echo "INFO| CREDENTIALS: $CREDENTIALS: OK"
#
[ -f  "$STORES" ] || {
	fatal "file $STORES not found"
	fatal "exiting"
	exit 4
}
info "STORES       : $STORES      : OK"
################################################################################
#                                                                              #
# parse credentials                                                            #
#                                                                              #
################################################################################
#
read -r _email _password BEARERID < "$CREDENTIALS"
info "BEARERID   : $BEARERID"
################################################################################
#                                                                              #
#	MAIN LOOP                                                                  #
#                                                                              #
################################################################################
while read -r LOCATIONID STOREID STORENAME STOREADDRESS
do
	info "LOCATIONID  : $LOCATIONID"
	info "STOREID     : $STOREID"
	info "STORENAME   : $STORENAME"
	info "STOREADDRESS: $STOREADDRESS"
	#
	info ./firefox.check.sh \
					"\"$LOCATIONID\"" \
					"\"$STOREID\"" \
					"\"$BEARERID\"" \
					"\"$STORENAME\"" \
					"\"$STOREADDRESS\"" \
					"\"$EMAIL\"" \
					"\"$TIMESERIAL\"" \
					EXECUTE \
					&> >(tee -a "${LOGDIR}/MASTER.log")
	############################################################################
	#                                                                          #
	#	FIREFOXCHECK                                                           #
	#                                                                          #
	############################################################################
	./firefox.check.sh \
			"$LOCATIONID" \
			"$STOREID" \
			"$BEARERID" \
			"$STORENAME" \
			"$STOREADDRESS" \
			"$EMAIL" \
			"$TIMESERIAL" \
			EXECUTE
	echo $?
	############################################################################
	#                                                                          #
	#	SLEEP                                                                  #
	#                                                                          #
	############################################################################
	SLEEPTIME=5
	info "SLEEP $SLEEPTIME"
	sleep 5
done < "$STORES"

info "${SCRIPTPATH}/json2mail.sh" "$OUTDIR" "$EMAIL" "$TIMESERIAL"
"${SCRIPTPATH}/json2mail.sh" "$OUTDIR" "$EMAIL" "$TIMESERIAL"
##echo for file in "${OUTDIR}"/"${EMAIL}".*.*."${TIMESERIAL}".json
#for file in "${OUTDIR}"/"${EMAIL}".*.200."${TIMESERIAL}".json
#do
#	[ -f "$file" ] || continue
#	echo $file
#done
