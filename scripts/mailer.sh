sendemail -l email.log     -f "sender@domain.com"      -u "Email Subject 2"      -t "receiver@domain.com"      -cc "receiver2@domain.com"      -bcc "receiver3@domain.com"      -s "smtp.***REMOVED***:587"      -o tls=yes      -xu "youremail@***REMOVED***"  echo mailbody | sendemail -l email.log     -f "***REMOVED***"      -u "Email Subject"      -t "***REMOVED***"  -s "smtp.***REMOVED***:587"      -o tls=yes      -xu "***REMOVED***" -xp "0Xp0rc0d10"
