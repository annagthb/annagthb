#!/usr/bin/perl

#idea=          calls Gams with the given input values. renames the gamsInput.inc to makeInc.inc
#input=         gamsInput.inc
#output=        gamsOutputXXX.txt
#previous=      makeGamsInput.pl
#successor=     LP.gms makeNetwork.pl

use strict;
use warnings;


my $standardName = "makeInc.inc";
my $inFile = $ARGV[0];
my $genomeID = substr($fileName, 8);
for($i = 0; $i < length($genomeID); $i++){
        if(substr($genomeID, $i, 1) eq "."){
                $genomeID = substr($genomeID, 0, $i);
        }
}
my $outputFile = "gamsOutput".$genomeID.".txt";

rename($fileName, $standardName);
system("../../../../kcbi/software/GAMS/gams LP.gms");
rename($standardName, $fileName);
rename("LP.lst", "LPG".$genomeID.".lst");
rename("output.txt", $outputFile);
rename("epsi_value.txt", "epsilonsG".$genomeID.".txt");

system("perl makeNetwork.pl"." $outputFile");
