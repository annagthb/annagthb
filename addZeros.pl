#!/usr/bin/perl
#idea=          adds evalue=0 for interactions with genomes that dont exist
#input=         takeLogXXX
#               arrayOfGenomes
#output=        addedZerosxxx.txt
#previous=      takeLog.pl
#successor=     

use strict;
use warnings;

#extract the genomeID
my $logFile = $ARGV[0]; #takeLogXXX
my $genomeID = substr($fileName, 7);
for($a = 0; $a < length($genomeID); $a++){
        if(substr($genomeID, $a, 1) eq "."){
                $genomeID = substr($genomeID, 0, $a);
        }
}

my $genomesFile = $ARGV[1];
my $outputFile = "addedZeros".$genomeID.".txt";
open(OUTPUT, ">>$outputFile") || die;

my @genomeIDs;
my $firstProteinID;
my $lastProteinID;

#reads genomesArray and then makes an array
open(IN_GENOMES, "<$genomeArrayFile") || die;
while(my $line= <IN_GENOMES>){
        chomp $line;
        my @array = split(/\t/, $line);
        if($array[0] == $genomeID){
                $firstProteinID = $array[1];
                $lastProteinD = $array[2];
        }
        push(@genomeIDs, $array6[0]);
}
close(IN_GENOMES);

my $nGenomes = @genomeIDs;
my @yGenomes;
sub exists{
        my $result= 0;
        for(my $i= 0; $i< @yGenomes; $i++){
                if($arrayOfGenomesIn[$i] == $_[0]){
                        $result= 1;
                }
        }
        return $result;
}

#find the firstProteinID and the lastProteinID from the GenomesArrayFile
for(my $i = $firstProteinID; $i <= $lastProteinID; $i++){
       # print "on pipeline number: ".$i."\n";
        #open(DATAIN, "takeLog.txt") || die;
        open(IN_BLAST, "<$logFile") || die "cannot open \"$logFile\": $!";
        while(my $line = <IN_BLAST>){
                chomp $line;
                my @array = split(/\t/, $line);
                if($array[0] == $i){
                        print OUTPUT "$line\n";
                        push(@yGenomes, $array[1]);
                }
        }
close(IN_BLAST);

        for(my $i= 0; $i < $nGenomes; $i++){
                if(exists($genomeIDs[$i]) == 0 && $genomeIDs[$i] != $genomeID){
                        print OUTPUT "$i\t$genomeIDs[$i]\t0\n";
                }
        }
        @yGenomes = ();
}
close(OUTPUT);

system("perl sortCells.pl"." $genomeID $outputFile $genomeArrayFile");
# $genomeArrayFile is arrayOfGenomes.txt
