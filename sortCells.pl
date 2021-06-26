#!/usr/bin/perl

#idea=          reorders the interactingYs of each proteinX according to the columns each Yj should have in the final matrix (order=order in arrayOfGenomes)
#input=         genomeID
#               addedZerosxxx.txt
#               arrayOfGenomes.txt
#output=        sortedXXX.txt
#previous=      addZeros.pl
#after=         makeMatrix.pl

use strict;
use warnings;

# use this to reorder the lines according to where they appear in the
# array of genomes file
#reorders the interactingYs of each proteinX according to the columns each Yj should have in the final matrix (order=order in arrayOfGenomes)

my $genomeID = $ARGV[0];
my $firstProteinID;
my $lastProteinD;

#find the start and end proteins of the Xgenome
open(IN_GENOMES, "<$ARGV[2]") || die "cannot open the file";#arrayOfGenomes

my @genomes;
my $counter= 0;
while(my $line = <IN_GENOMES>){#genomeID startProtein endProtein
        chomp $line;
        my @array = split(/\t/, $line);
        if($array[0] == $genomeID && $counter== 0){#if Xgenome
                $firstProteinID = $array[1];#start protein
                $lastProteinID = $array[2];#end protein
                $counter++;
        }
        if($array[0] != $genomeID){#Ygenomes array
                push(@genomes, $array[0]);
        }
}
close(IN_GENOMES);

#submethod to reture the position of the current genome
sub whichPosition{#within a sub @_ contains the passed pars
        for(my $i = 0; $i < @genomes; $i++){#go through yGenomes
                if($_[0] == $genomes[$i]){#if passed yGenome is in the arrayOfYgenomes at row i
                        return $i;#return its row (the position it should have - like the number of its column in the final matrix
                }
        }
}


#for each xProtein, its Yinteractions are printed in the order found in the arrayOfYgenomes
my $outputFileName = "sorted".$ARGV[0].".txt";
open(OUTPUT, ">>$outputFileName");
open(IN_BLAST, "<$ARGV[1]") || die "cannot open \"$ARGV[1]\": $!";#previousOutput

for(my $i = $firstProteinID; $i <= $lastProteinID; $i++){#for each xProtein
        my @sorted;#a new order
        for(my $j= 0; $j < @genomes; $j++){#go through Ygenomes
                my $line = <IN_BLAST>;#previousOutput
                my @array = split(/\t/, $line);#row (xProtein, YinteractingGenome, log)
                my $position = whichPosition($array[1]);#par=YinteractingGenome output=1..nYgenomes
                $sorted[$position] = $line;#interacting Ys for each protein should appear in the order they are found in the arrayYgenomes
        }
        for(my $k = 0; $k < @sorted; $k++){
                print OUTPUT "$sorted[$k]";#for the given xProtein print the interactingYs in the order they are in the arrayYgenomes
        }
}
close(IN_BLAST);
close(OUTPUT);

system("perl makeMatrix.pl"." $outputFileName $ARGV[2]");
#$ARGV[2] is arrayOfGenomes.txt
