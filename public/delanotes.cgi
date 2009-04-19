#!/usr/bin/perl

#-----------------------
#  CODE THAT RUNS ONCE
#-----------------------

BEGIN {
    my $perldir = "local";
    my @additional_vers = qw( );

    $HOME=(getpwuid($>))[7];    
    my $perlver = $];
    $perlver =~ s/^(\d+)\.(\d\d\d)(\d\d\d)$/"$1.".(0+$2).".".(0+$3)/e;
    my( $majorver ) = ($perlver =~ m/^(\d+\.\d+)/);
    my @baselibs = qw( lib/perl share/perl );
    my @libs;
    for my $ver ( $perlver, $majorver, @additional_vers ) {
        for ( @baselibs ) {
            push @libs, "$HOME/$perldir/$_/$ver";
        }
    }
    require lib;
    lib->import( @libs );
}

use Data::Dumper;

use CGI::Fast;
use BSD::Resource;
use HTML::Entities;


use constant MB => 1024 * 1024;
%::RESOURCE_LIMITS = (
    RLIMIT_DATA  =>  25 * MB,
    RLIMIT_AS    => 100 * MB,
    RLIMIT_VMEM  => 100 * MB,
    RLIMIT_RSS   =>  75 * MB,
    RLIMIT_STACK =>   8 * MB,
    RLIMIT_CORE  =>   0,
    );
                            

my $limits = get_rlimits();
for (keys %::RESOURCE_LIMITS ) {
    my($osoft, $ohard) = getrlimit( $$limits{$_} );
    my $nhard = $::RESOURCE_LIMITS{$_} * 1.25;
    setrlimit( $$limits{$_}, $::RESOURCE_LIMITS{$_}, $nhard )
        or warn "Failed to set $_\n";
}


#---------------------------------
#  CODE THAT RUNS EVERY TIME
#---------------------------------



REQUEST:
while (my $cgi = CGI::Fast->new ) {
      print "Content-type:text/plain\n\n";
      
      print Dumper(\%ENV);
      print Dumper($cgi);

}
