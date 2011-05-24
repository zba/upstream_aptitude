#!/usr/bin/perl
use strict;
my $num   = ( @ARGV[0] or 1 );
my $spatt = ( @ARGV[1] or '!~M ~U' );
my $a=1;
my $out;
while ($a==1) {
$out='';
print "will remove last $num dot and search by '$spatt'\n";
open( apti, "aptitude -w 3000 -F '%p %50v %50V' search '$spatt'|" );
while (<apti>) {
my ($p,$old_real,$new_real)=split(/\s+/,$_);
    my $o=$old_real;
    my $n=$new_real;
    $o =~ s/[\-\~].+$//;
    $n =~ s/[\-\~].+$//;
    my @old = split( /\./, $o );
    my @new = split( /\./, $n );
    my $ol  = scalar(@old);
    $o = $n = "";
    my $lim=$ol-$num; if ($lim<0) {$lim=0;}
    for ( my $a = 0 ; $a <= $lim; $a++ ) {
        $o .= "$old[$a].";
        $n .= "$new[$a].";
    }
    if ( ! ($o eq $n) ) { $out.="$p $old_real -> $new_real \n"};
}
if (scalar(split(/\n/,$out))<100)  {$a=0};
$num++;
if ($num>10) {$a=0}
}
print $out;
