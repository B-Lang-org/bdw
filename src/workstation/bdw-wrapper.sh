#! /usr/bin/env bash

# Find the absolute name and location of this script
#
ABSNAME="$(cd "${0%/*}"; echo $PWD)/${0##*/}"
SCRIPTNAME="${ABSNAME##*/}"
BINDIR="${ABSNAME%/*}"

# Set BDWDIR based on the location
BDWDIR="$(cd ${BINDIR}/../lib; echo $PWD)"
export BDWDIR

# Determine the actual executable to run
BDWEXEC=${BINDIR}/core/${SCRIPTNAME}

if [ ! -x "$BDWEXEC" ] ; then
    echo "Error BDW executable not found: ${BDWEXEC}"
    exit 1;
fi

exec $BDWEXEC "$@"
