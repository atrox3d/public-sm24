#!/bin/bash
#SCRIPTPATH="$(dirname $(realpath $0))"
#INCLUDE="$(realpath ${SCRIPTPATH}/../include/functions.include)"
#LOGDIR="$(realpath ${SCRIPTPATH}/../log)"
SCRIPTPATH="$(dirname $(readlink -f $0))"
INCLUDE="$(readlink -f  ${SCRIPTPATH}/../include/functions.include)"
LOGDIR="$(readlink -f  ${SCRIPTPATH}/../log)"

. "$INCLUDE" ||  { echo "ERROR|cannot source $INCLUDE" | tee -a "${LOGDIR}/crontab.log"; exit 1; }

info "$LOGDIR" 2>&1 | tee -a "${LOGDIR}/crontab.log"

