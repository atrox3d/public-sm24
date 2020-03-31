#!/bin/bash
SCRIPTPATH="$(dirname $(realpath $0))"
INCLUDE="${SCRIPTPATH}/functions.include"
LOGDIR="${SCRIPTPATH}/log"

. "$INCLUDE"
echo "$(timestamp) - $LOGDIR" 2>&1 | tee -a "${LOGDIR}/crontab.log"

