#!/bin/bash
MAILLOG=log/sendemail.log

[ $# -ge 3 ] || { echo "syntax: $0 address subject message [[attachment]...]"; exit 1; }

MAILTO="$1"
SUBJECT="$2"
MESSAGE="$3"
SMTPSERVER=smtp.***REMOVED***
SMTPPORT=587
MAILADDRESS=***REMOVED***
MAILUSER=***REMOVED***
MAILPASSWORD=0Xp0rc0d10

if [ $# -ge 4 ]
then
	shift
	shift
	shift
	echo found $# attachments $*

	for attachment in $*
	do
		echo check attachment -a -$attachment
		ATTACHMENTS="$ATTACHMENTS -a $attachment"
	done
	echo ATTACHMENTS:$ATTACHMENTS
	#echo
	sendemail \
		-s  "${SMTPSERVER}:${SMTPPORT}" \
		-xu "$MAILUSER" \
		-xp "$MAILPASSWORD"  \
		-f  "$MAILADDRESS" \
		-cc "***REMOVED***" \
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
		-cc "***REMOVED***" \
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
