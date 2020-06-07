#!/bin/bash
################################################################################
#	.config.sh
#	set variables, paths, ecc.
#	to be sourced from ALL scripts
################################################################################
#	STARTPATH                                                                  #
################################################################################
STARTPATH="$(pwd)"
################################################################################
#	SCRIPTPATH                                                                 #
################################################################################
SCRIPTPATH="$(dirname $(readlink -f $0))"
################################################################################
#	SOURCENAME                                                                 #
################################################################################
SOURCENAME="$(basename $BASH_SOURCE)"
################################################################################
#	SOURCEPATH                                                                 #
################################################################################
SOURCEPATH="$(dirname $(readlink -f $BASH_SOURCE))"
################################################################################
#	SCRIPTNAME                                                                 #
################################################################################
SCRIPTNAME="$(basename $0)"
################################################################################
#	INCLUDEPATH                                                                #
################################################################################
INCLUDEPATH="${SCRIPTPATH}/include"
################################################################################
#	INCLUDE                                                                    #
################################################################################
INCLUDE="${INCLUDEPATH}/functions.include"
################################################################################



cd "$SCRIPTPATH"
