#!/bin/bash
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
