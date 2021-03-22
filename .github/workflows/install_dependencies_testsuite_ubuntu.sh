#!/usr/bin/env bash

apt-get update

# The name of the itk package to install
# NB itk depends on itcl, tk and tcl, so no need to install those separately
#
# For the moment, bdw only works with itk3
#ITK_PKG=$(apt-cache search -n '^(tk-)?itk[0-9]-dev' | cut -f1 -d' ' | sort | tail -1)
ITK_PKG=itk3

apt-get install -y \
    ccache \
    build-essential \
    tcsh \
    dejagnu \
    iverilog \
    $ITK_PKG \
    xvfb

REL=$(lsb_release -rs | tr -d .)
if [ $REL -ge 1804 ]; then
    apt-get install -y lld
fi
