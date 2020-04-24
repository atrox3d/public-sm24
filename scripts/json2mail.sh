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
################################################################################
checkparameters $# 5 "$(basename $BASH_SOURCE) LOGDIR DATADIR OUTDIR EMAIL TIMESERIAL" || exit 1
LOGDIR="$1"
DATADIR="$2"
OUTDIR="$3"
EMAIL="$4"
TIMESERIAL="$5"
DONTMAIL="${DATADIR}/DONTMAIL"
MASTERLOG="${LOGDIR}/MASTER.log"
################################################################################
#	forzo bro mail                                                             #
################################################################################
[ "$EMAIL" == "***REMOVED***" ] && {
	info "forzo ***REMOVED***"
	MAILLOG="$EMAIL"
	EMAIL=***REMOVED***
} || {
	MAILLOG="$EMAIL"
}
################################################################################
PATTERN="${OUTDIR}"/"${MAILLOG}".*.200."${TIMESERIAL}".json
MAILPATTERN="${OUTDIR}"/"${MAILLOG}"."${TIMESERIAL}".mail
################################################################################
info "################################################################################"
info "LOGDIR    : $LOGDIR"
info "DATADIR   : $DATADIR"
info "DONTMAIL  : $DONTMAIL"
info "OUTDIR    : $OUTDIR"
info "EMAIL     : $EMAIL"
info "MAILLOG   : $MAILLOG"
info "TIMESERIAL: $TIMESERIAL"
info "PATTERN   : $PATTERN"
info "MASTERLOG : $MASTERLOG"
info "################################################################################"
info "check jq"
which jq &> /dev/null || {
	fatal "#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#"
	fatal "#FATAL#                                                                 #FATAL#"
	fatal "#FATAL#               IMPOSSIBILE TROVARE JQ                            #FATAL#"
	fatal "#FATAL#                                                                 #FATAL#"
	fatal "#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#"
	exit 1
}
info "ok"
info "################################################################################"
info "START"
info "################################################################################"
SENDMAIL=OFF
for file in $PATTERN
do
	[ -f "$file" ] || continue
	SENDMAIL=ON
	#echo "DEBUG| $file" >&2
	#
	#	extract store
	#
	filename="$(basename $file)"
	#
	#	removing email from filename
	#	to avoid parsing email's dots
	#
	filename=${filename#${MAILLOG}.}
	#IFS=. read -r mail domain STORE status date timestamp <<< "$filename"
	IFS=. read -r STORE status date timestamp <<< "$filename"
	echo $STORE
	echo
	#cat $file | jq '.data.data[].hours[] | .label'
	cat $file | jq '.data.data[]| { "lbl": .label, "hrs": .hours[].time_label } | "\(.lbl) \(.hrs)"'
	echo
done > "$MAILPATTERN"

[ $SENDMAIL == ON ] && {
	################################################################################
	#                                                                              #
	# DONTMAIL                                                                     #
	#                                                                              #
	################################################################################
	[ -f  "${DONTMAIL}" ] && {
		{
			warn "#######################################################################################"
			warn "# ${EMAIL} | found '${DONTMAIL}'"
			warn "# ${EMAIL} | skip mail"
			warn "# ${EMAIL} | exiting"
			warn "#######################################################################################"
		} |& tee -a "${MASTERLOG}"
		exit 0
	}
	################################################################################
	info "trovati slots, mando mail"
	info "" ./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
	./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
} || {
	info "nessuno slot trovato"
	info "cancellazione $MAILPATTERN"
	rm "$MAILPATTERN"
}

