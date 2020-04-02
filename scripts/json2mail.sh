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
INCLUDE="${SCRIPTPATH}/functions.include"
################################################################################
#                                                                              #
#	load include                                                               #
#                                                                              #
################################################################################
. "$INCLUDE" || { echo "ERROR|cannot source $INCLUDE"; exit 1; }
################################################################################
checkparameters $# 3 "$(basename $BASH_SOURCE) OUTDIR EMAIL TIMESERIAL"
OUTDIR="$1"
EMAIL="$2"
TIMESERIAL="$3"
PATTERN="${OUTDIR}"/"${EMAIL}".*.200."${TIMESERIAL}".json
MAILPATTERN="${OUTDIR}"/"${EMAIL}"."${TIMESERIAL}".mail

echo "INFO| OUTDIR    : $OUTDIR"
echo "INFO| EMAIL     : $EMAIL"
echo "INFO| TIMESERIAL: $TIMESERIAL"
echo "INFO| PATTERN   : $PATTERN"

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
	filename=${filename#${EMAIL}.}
	#IFS=. read -r mail domain STORE status date timestamp <<< "$filename"
	IFS=. read -r STORE status date timestamp <<< "$filename"
	echo $STORE
	echo
	cat $file | jq '.data.data[].hours[] | .label'
	echo
done > "$MAILPATTERN"

[ $SENDMAIL == ON ] && {
	echo "INFO| trovati slots, mando mail"
	echo "INFO| " ./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
	./mailer.sh "$EMAIL" "$EMAIL - SM24" "$(cat $MAILPATTERN)"
} || {
	echo "INFO| nessuno slot trovato"
	echo "INFO| cancellazione $MAILPATTERN"
	rm "$MAILPATTERN"
}

