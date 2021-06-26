#!/usr/bin/perl
#based on Ahmed's idea ( a last year student)
#idea=remove rows which all its col values are the same
#input=         matrixXXX.txt
#               arrayOfGenomes.txt
#output=        rmvedSamesXXX.txt
#previous=      makeMatrix.pl
#successor=     rmvDominated.pl

use strict;
use warnings;

#go through each line and check whether the first Col is the same with all the rest

open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";
my $inputName= $ARGV[0];
my $genomeID = substr($inputName, 15);
for($i = 0; $i < length($genomeID); $i++){
        if(substr($genomeID, $i, 1) eq "."){
                $genomeID = substr($genomeID, 0, $i);
        }
}

my $outName = "rmvedSames".$genomeID.".txt";
open(OUTPUT, ">>$outName") || die "cannot open inc.inc";

my $counter = 0;
while(my $line = <IN_BLAST>){
        chomp $line;
        my @array = split(/\t/, $line);
        if($counter == 0){
                print OUTPUT $line."\n";
                $counter++;
        }
        else{
                my $firstCol = 0;
                my $isSame = 1;
                for(my $i = 1; $i < @array; $i++){
                        if($i == 1){
                                $firstCol = $array[$i];
                        }
                        else{
                                if($firstCol!= $array[$i]){
                                        $i = @array;
                                        $isSame = 0;
                                }
                        }
                }
                if($isSame == 0){
                        print OUTPUT "$line\n";
                }
        }
}

close(IN_BLAST);
close(OUTPUT);

system("perl rmvDominated.pl"." $outputFileName $ARGV[1]");


# $ARGV[1] is arrayOfGenomes.txt
