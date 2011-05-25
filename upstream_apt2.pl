#!/usr/bin/perl
use strict;
my @outs;
my $num   = ( @ARGV[0] or 3 );
$num--;
my $spatt = ( @ARGV[1] or '!~M ~U ~aupgrade' );
my $a=1;
my $out;
while ($a==1) {
$out='';
print stderr "will leave leading ".($num+1)." dots and search by '$spatt'\n";
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
    for ( my $a = 0 ; $a <= $num ; $a++ ) {
        $o .= "$old[$a].";
        $n .= "$new[$a].";
    }
    if ( ! ($o eq $n) ) { $out.="$p $old_real -> $new_real \n"};
#	print "p $old_real $new_real\n";
}
$outs[$num]=$out;
if (scalar(split(/\n/,$out))<100)  {$a=0};
$num--;
if ($num<0) {$a=0;$num=0}
}

while (scalar(split(/\n/,$out))==0) {$num++;$out=$outs[$num];if ($num>100) {print STDERR "sorry, no packages to upgrade \n";exit;} }
print $out;
