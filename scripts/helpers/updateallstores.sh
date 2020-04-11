#!/bin/bash
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

for mail in ../../data/*/
do
	mail="$(basename $mail)"
	storesfile="../data/${mail}/stores"
	echo "$(timestamp)|mail:$mail|stores file: $storesfile"
	./createstores.sh "$mail" > "$storesfile"
done

