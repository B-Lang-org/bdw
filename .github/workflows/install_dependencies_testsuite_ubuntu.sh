#!/usr/bin/env bash

apt-get update

# Install the latest version of itcl/itk -- itk3 or tk-itk4.
# NB itk depends on itcl, tk and tcl, so no need to install those separately
ITK_PKG=$(apt-cache search -n '^(tk-)?itk[0-9]-dev' | cut -f1 -d' ' | sort | tail -1)

apt-get install -y \
    ccache \
    build-essential \
    tcsh \
    dejagnu \
    iverilog \
    $ITK_PKG

REL=$(lsb_release -rs | tr -d .)
if [ $REL -ge 1804 ]; then
    apt-get install -y lld
fi
