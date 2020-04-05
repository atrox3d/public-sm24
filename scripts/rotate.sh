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
################################################################################
MINPARAMS=1
checkparameters $# $MINPARAMS "$(basename $BASH_SOURCE) log|out|all [TIMESERIAL]" || exit 1
#
WHAT="${1,,}"
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
TIMESERIAL="$(timeserial)"
LOGFILE="${LOGDIR}/rotate.log"
################################################################################
#                                                                              #
#                                                                              #
#                                                                              #
#	EXEC                                                                       #
#                                                                              #
#	echo "This will be logged to the file and to the screen"                   #
#	exec >> "$LOGFILE"                                                         #
#	exec 2>&1                                                                  #
#                                                                              #
#                                                                              #
################################################################################
info "#######################################################################################"
info "redirecting to STDOUT and $LOGFILE"
info "#######################################################################################"
exec &> >(tee -a "$LOGFILE")
info "#######################################################################################"
info "WHAT                 : $WHAT"
info "TIMESERIAL_YESTERDAY : $TIMESERIAL_YESTERDAY"
################################################################################
#                                                                              #
#	                                                                           #
#                                                                              #
################################################################################
SCOPES=()
case $WHAT in
	log)
		SCOPES+=("$LOGDIR")
		;;
	out)
		SCOPES+=("$OUTDIR")
		;;
	all)
		SCOPES+=("$LOGDIR")
		SCOPES+=("$OUTDIR")
		;;
	*)
	;;
esac

for scope in "${SCOPES[@]}"
do
	#echo "INFO| current scope : $scope"
	#FILESTODELETE="${scope}/*${TIMESERIAL_YESTERDAY}*"
	#echo "INFO| FILESTODELETE : $(echo $FILESTODELETE)"
	#rm $FILESTODELETE || echo "ERROR| deleting files"
	info "current scope : $scope"
	PATTERN="${scope}/*${TIMESERIAL_YESTERDAY}*"
	DESTDIR="${scope}/${TIMESERIAL_YESTERDAY}"
	for file in $PATTERN
	do
		[ -f "$file" ] || continue
		info $file
		mkdir -p "$DESTDIR" || error "cannot create $DESTDIR"
		mv "$file" "$DESTDIR"
	done
	
done

