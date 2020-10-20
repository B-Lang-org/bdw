#!/bin/bash
set -euo pipefail

export TMOUT=1

# -------------------------
# GIT

genGITBuildVersion () {
    sed "s/REVISION/$1/g" version_commands.tcl.template > version_commands.tcl.new;
    if test -f version_commands.tcl; then
	if !(diff version_commands.tcl version_commands.tcl.new); then
            mv version_commands.tcl.new version_commands.tcl;
	else
            echo "version_commands.tcl up-to-date";
            rm version_commands.tcl.new;
	fi;
    else
	mv version_commands.tcl.new version_commands.tcl;
    fi;
}

# -------------------------

if ( test -f version_commands.tcl ) && [ "$NOUPDATEBUILDVERSION" = 1 ] ; then
    echo "version_commands.tcl not modified"
else

    if [ "$NOGIT" = 1 ] ; then
	GITCOMMIT="0000000"
    else
	GITCOMMIT=`git show -s --format=%h HEAD`
    fi
    genGITBuildVersion ${GITCOMMIT}

fi

# -------------------------
