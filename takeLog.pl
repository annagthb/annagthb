#!/usr/bin/perl
#idea=          takes the log of the evalues in the input file chooseBest.pl
#input=         bestXXX.txt
#               genomeID
#               arrayOfGenomes
#output=        takeLogXXX.txt
#previous=      chooseBest.pl
#successor=     addZeros.pl

use strict;
use warnings;

open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";

my $genomeID = $ARGV[1];
my $outFile = "takeLog".$genomeID.".txt";
my $GenomesFile = $ARGV[2];

open(OUTPUT, ">>$fileName");

while(my $line = <IN_BLAST>){
        chomp $line;
        my @array = split(/\t/, $line);
        my $logarithm = -log($array[2]);
        print OUTPUT "$array[0]\t$array[3]\t$logarithm\n";
}

close(IN_BLAST);
close(OUTPUT);

system("perl addZeros.pl"." $outFile $GenomesFile");
# $arrayOfGenome is arrayOfGenomes.txt
