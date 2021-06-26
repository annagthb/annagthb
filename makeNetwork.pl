#!/usr/bin/perl
#based on Ahmed's idea ( a last year student)
#idea=creates the network from the Gams solution
#input=         gamsOutputXXX.txt
#output=        network.txt
#previous=      runGams.pl
#successor=     ----------

use strict;
use warnings;

my $inputFile = $ARGV[0]; #this is the output file that has been created by runGAMS.pl
my $genomeID = substr($fileName, 10);
for(my $i= 0; $i< length($genomeID); $i++){
        if(substr($genomeID, $i, 1) eq "."){
                $genomeID = substr($genomeID, 0, $i);
        }
}

my $outputFile = "network.txt";
open(OUTPUT, ">>$outputFile") || die "cannot open outputfile";
open(IN_SOLUTION, "<$fileName") || die "cannot open inputfile";
while(my $line = <IN_SOLUTION>){
        chomp $line;
        my @array = split(/\t/, $line);
        my $line = substr($array[0], 1);
        my $position = index($line, " ");
        my $donorID = substr($line, 0, $position);
        my $value = substr($line, $position);
        my $keepGoing = 1;
        while($keepGoing == 1){
                $position = index($value, " ");
                if($position != -1){
                        $value = substr($value, $position+1);
                }
                else {
                        $keepGoing = 0;
                }
        }
        print OUTPUT "$donorID\t$genomeID\t$value\n";
}
close(IN_SOLUTION);
close(OUTPUT);
