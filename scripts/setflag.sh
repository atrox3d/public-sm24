#!/bin/bash
################################################################################
#                                                                              #
#	START                                                                      #
#                                                                              #
################################################################################
STARTPATH="$(pwd)"
#SCRIPTPATH="$(dirname $(realpath $0))"
SCRIPTPATH="$(dirname $(readlink -f $0))"
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
################################################################################
#                                                                              #
# setflag mail flag on|off [ -d datadir -l logdir -o outdir ]                  #
#                                                                              #
################################################################################
checkparameters $# 3 "$(basename $BASH_SOURCE) mail flag on|off [ -d datadir -l logdir -o outdir ]" || exit 1
################################################################################
#                                                                              #
# DEFAULTS                                                                     #
#                                                                              #
################################################################################
DATADIR="${SCRIPTPATH}/../data"
LOGDIR="${SCRIPTPATH}/log"
OUTDIR="${SCRIPTPATH}/output"
################################################################################
MAIL="${1,,}"
FLAG="${2^^}"
ONOFF="${3,,}"
################################################################################
MASTERLOG="${LOGDIR}/MASTER.log"
################################################################################
info "################################################################################"
info "DATADIR   : ${DATADIR}"
info "LOGDIR    : ${LOGDIR}"
info "OUTDIR    : ${OUTDIR}"
info "MAIL      : ${MAIL}"
info "FLAG      : ${FLAG}"
info "ONOFF     : ${ONOFF}"
info "MASTERLOG : ${MASTERLOG}"
info "################################################################################"
################################################################################
for dir in "${DATADIR}" "${LOGDIR}" "${OUTDIR}"
do
	info "check ${dir}"
	[ -d "${dir}" ] || { fatal "directory ${dir} not found"; exit 1; }
	info "ok"
done
#
[ -d "${DATADIR}/${MAIL}"  ] || { fatal "invalid mail: ${MAIL}"; exit 1; }
################################################################################
case $ONOFF in
	on)
		[ -f "${DATADIR}/${MAIL}/DONT${FLAG}" ] && {
			rm "${DATADIR}/${MAIL}/DONT${FLAG}"
		}
	;;
	off)
		touch "${DATADIR}/${MAIL}/DONT${FLAG}"
	;;
	*)
		fatal "FLAG must be on or off, got '$ONOFF'"
	;;
esac

