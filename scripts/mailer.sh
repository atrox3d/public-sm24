#!/bin/bash
MAILLOG=log/sendemail.log

[ $# -ge 3 ] || { echo "syntax: $0 address subject message [[attachment]...]"; exit 1; }

mailto="$1"
subject="$2"
message="$3"
smtpserver=smtp.***REMOVED***
smtpport=587
mailaddress=***REMOVED***
mailuser=***REMOVED***
mailpassword=0Xp0rc0d10

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
		-s  "${smtpserver}:${smtpport}" \
		-xu "$mailuser" \
		-xp "$mailpassword"  \
		-f  "$mailaddress" \
		-t  "$mailto" \
		-u  "$subject" \
		-m  "$message" \
		-l  "$MAILLOG" \
		-a ${ATTACHMENTS}
else
	sendemail \
	-s  "${smtpserver}:${smtpport}" \
	-xu "$mailuser" \
	-xp "$mailpassword"  \
	-f  "$mailaddress" \
	-t  "$mailto" \
	-u  "$subject" \
	-m  "$message" \
	-l  "$MAILLOG"
fi
 
exit


#    -cc "receiver2@domain.com"  \
#    -bcc "receiver3@domain.com"  \

echo "hello" | sendemail -l email.log \
    -f "***REMOVED***"  \
    -u "test"  \
    -t "***REMOVED***"  \
    -s "smtp.***REMOVED***:587"  \
    -o tls=yes  \
    -xu "***REMOVED***"  \
    -xp "0Xp0rc0d10" 
