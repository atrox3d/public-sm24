#!/bin/bash
SCRIPTPATH="$(dirname $(readlink -f $0))"
INCLUDE="$(readlink -f  ${SCRIPTPATH}/../include/functions.include)"
LOGDIR="$(readlink -f  ${SCRIPTPATH}/../log)"

. "$INCLUDE" ||  { echo "ERROR|cannot source $INCLUDE" | tee -a "${LOGDIR}/crontab.log"; exit 1; }

function join_by { local IFS="$1"; shift; echo "$*"; }

#info "PARAMS: $(join_by , $@) | LOGFLE: $LOGDIR/crontab.log" 2>&1 | tee -a "${LOGDIR}/crontab.log"
info "PARAMS: $(join_by , $@) | LOGFLE: $LOGDIR/crontab.log"
