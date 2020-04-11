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

LOGPATH="${SCRIPTPATH}/log"
MAILLOG="${LOGPATH}/sendemail.log"

[ $# -ge 3 ] || { fatal "syntax: $0 address subject message [[attachment]...]"; exit 1; }

MAILTO="$1"
SUBJECT="$2"
MESSAGE="$3"
SMTPSERVER=smtp.***REMOVED***
SMTPPORT=587
MAILADDRESS=***REMOVED***
MAILUSER=***REMOVED***
MAILPASSWORD=0Xp0rc0d10
MAILCC=***REMOVED***
info "################################################################################"
info "MAILTO       : $MAILTO"
info "SUBJECT      : $SUBJECT"
info "MESSAGE      : $MESSAGE"
info "SMTPSERVER   : $SMTPSERVER"
info "SMTPPORT     : $SMTPPORT"
info "MAILADDRESS  : $MAILADDRESS"
info "MAILCC       : $MAILCC"
info "MAILUSER     : $MAILUSER"
info "MAILPASSWORD : $MAILPASSWORD"
info "################################################################################"
info "check sendemail"
which sendemail &> /dev/null || {
	fatal "#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#"
	fatal "#FATAL#                                                                 #FATAL#"
	fatal "#FATAL#               IMPOSSIBILE TROVARE SENDEMAIL                     #FATAL#"
	fatal "#FATAL#                                                                 #FATAL#"
	fatal "#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#FATAL#"
	exit 1
}
info "ok"
info "################################################################################"
info "START"
info "################################################################################"

if [ $# -ge 4 ]
then
	shift
	shift
	shift
	info "found $# attachments $*"

	for attachment in $*
	do
		info "check attachment -a -$attachment"
		ATTACHMENTS="$ATTACHMENTS -a $attachment"
	done
	info "ATTACHMENTS:$ATTACHMENTS"
	#echo
	sendemail \
		-s  "${SMTPSERVER}:${SMTPPORT}" \
		-xu "$MAILUSER" \
		-xp "$MAILPASSWORD"  \
		-f  "$MAILADDRESS" \
		-cc "$MAILCC" \
		-t  "$MAILTO" \
		-u  "$SUBJECT" \
		-m  "$MESSAGE" \
		-l  "$MAILLOG" \
		-a ${ATTACHMENTS}
else
	sendemail \
		-s  "${SMTPSERVER}:${SMTPPORT}" \
		-xu "$MAILUSER" \
		-xp "$MAILPASSWORD"  \
		-f  "$MAILADDRESS" \
		-cc "$MAILCC" \
		-t  "$MAILTO" \
		-u  "$SUBJECT" \
		-m  "$MESSAGE" \
		-l  "$MAILLOG"
fi
 

#exit
#
##    -cc "receiver2@domain.com"  \
##    -bcc "receiver3@domain.com"  \
#
#echo "hello" | sendemail -l email.log \
#    -f "***REMOVED***"  \
#    -u "test"  \
#    -t "***REMOVED***"  \
#    -s "smtp.***REMOVED***:587"  \
#    -o tls=yes  \
#    -xu "***REMOVED***"  \
#    -xp "0Xp0rc0d10" 
