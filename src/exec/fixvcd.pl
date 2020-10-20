#!/usr/bin/perl --
# -*-Perl-*-
##############################################################################
##############################################################################

$vcd_file = shift ;

unless ($vcd_file)
{
    print STDERR "\nERROR (fixvcd) : Missing vcd_file\n\n" ;
    print STDERR "Usage: fixvcd vcd_file\n\n" ;
    exit -1 ;
}

system("perl -i -pe 's/([^ ]+)(\\[[0-9]+:[0-9]+\\])/\$1 \$2/g;s/\\[0:0\\]//g' $vcd_file")


