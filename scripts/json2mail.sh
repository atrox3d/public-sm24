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
checkparameters $# 3 "$(basename $BASH_SOURCE) OUTDIR EMAIL TIMESERIAL" || exit 1
OUTDIR="$1"
EMAIL="$2"
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
TIMESERIAL="$3"
PATTERN="${OUTDIR}"/"${MAILLOG}".*.200."${TIMESERIAL}".json
MAILPATTERN="${OUTDIR}"/"${MAILLOG}"."${TIMESERIAL}".mail

info "################################################################################"
info "OUTDIR    : $OUTDIR"
info "EMAIL     : $EMAIL"
info "MAILLOG   : $MAILLOG"
info "TIMESERIAL: $TIMESERIAL"
info "PATTERN   : $PATTERN"
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
	info "trovati slots, mando mail"
	info "" ./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
	./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
} || {
	info "nessuno slot trovato"
	info "cancellazione $MAILPATTERN"
	rm "$MAILPATTERN"
}

