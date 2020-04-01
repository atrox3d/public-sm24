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
MINPARAMS=1
checkparameters $# $MINPARAMS "$(basename $BASH_SOURCE) log|out|all [TIMESERIAL]"
#
WHAT="${1,,,}"
#
shift
[ $# -gt 0 ] && {
	TIMESERIAL_YESTERDAY="$1"
} || {
	TIMESERIAL_YESTERDAY="$(date +%Y%m%d -d "yesterday")"
}
################################################################################
#                                                                              #
#	SET VARIABLES                                                              #
#                                                                              #
################################################################################
CURDIR="$(pwd)"
DATADIR="${SCRIPTPATH}/../data/$EMAIL"
LOGDIR="${SCRIPTPATH}/log"
OUTDIR="${SCRIPTPATH}/output"
#TIMESERIAL="$(timeserial)"
#LOGFILE="${LOGDIR}/${EMAIL}.${TIMESERIAL}.log"
echo "INFO| TIMESERIAL_YESTERDAY : $TIMESERIAL_YESTERDAY"

