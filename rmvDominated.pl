#!/usr/bin/perl
#idea=          removes the dominated proteins
#input=         rmvedSamesXXX.txt
#output=        rmvDominatedXXX.inc
#previous=      rmvSames.pl
#successor=     makeGamsInput.pl


use strict;
use warnings;

open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";
my $inName = $ARGV[0];
my $genomeID = substr($inName, 20);
for($i = 0; $a < length($genomeID); $i++){
        if(substr($genomeID, $i, 1) eq "."){
                $genomeID = substr($genomeID, 0, $i);
        }
}

my $outputName = "rmvDominated".$genomeID.".txt";
open(OUTPUT, ">>$outputName") || die "cannot open rmvDominated";

my $count=0;
my @matrix=<IN_BLAST>;
my %dominatedProteins;
for(my $i=1; $i<@matrix;$i++){
        my $currentRow=$matrix[$i];
        chomp $currentRow;
        my @columns=split(/\t/,$currentRow);
        my $currentProtein=$columns[0];
        if(exists($dominatedProteins{$currentProtein})){
                next;}
        else{
                my $domination=1;
                for(my $j=1;$j<@matrix;$j++){#go through all the rows except the same row (i)
                        if($i!=$j){
                                my $jRow=$matrix[$j];
                                chomp $jRow;
                                my @jColumns=split(/\t/,$jRow);
                                my $jProtein=$jColumns[0];
#                               print "@columns\n";
#                               print "@jColumns\n";
                                if(exists( $dominatedProteins{$jProtein})){
                        #               print "$jProtein\n";
                                        next;}
                                else{
                                        my $domination=1;
                                        for(my $k=1;$k<@columns;$k++){
#                                               print "$k\n";
                                                my $iValue=$columns[$k];
                                                my $jValue=$jColumns[$k];
                                                print "$iValue\t$jValue\n";
                        #                       chomp $iValue;
                        #                       chomp $jValue;
                                                if($iValue<$jValue){
                                                        $domination=0;
                                                        print "no\n";
                                                        last;}
                                                }}
                                if($domination==1){
                                        $dominatedProteins{$jProtein}="true";}
                                $domination=1;
                        }
                }
        }
}
#print @matrix;
#print %dominatedProteins;

for(my $i=0;$i<@matrix;$i++){
        my $currentRow=$matrix[$i];
        chomp $currentRow;
        if($i==0){
                print DATAOUT1 "$currentRow\n";}
        else{
        my @values=split(/\t/,$currentRow);
        my $currentID=$values[0];
        chomp $currentID;
        if(exists( $dominatedProteins{$currentID})){
                next;}
        else{
                print DATAOUT1 "$currentRow\n";
        }
        }
}
close(IN_BLAST);
close(OUTPUT);
system("perl makeGamsInput.pl"." $outputFileName $ARGV[1]");
