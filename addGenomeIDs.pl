#!/usr/bin/perl
#idea=adds the corresponding genomeIDs for each gene
#input=         proteinIDs
#               arrayOfGenomes
#               BLASTxxx
#output=        addedGenomesXXX.txt
#previous=      chopBLAST.pl
#successor=     chooseBest.pl

use strict;
use warnings;
open(IN_PROTEINS,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!"; # PipeIDGenomeID is input 1
open(IN_GENOMES,"<$ARGV[1]") || die "cannot open \"$ARGV[1]\": $!"; # arrayOfGenomes.txt is input 2
#open(DATAIN3,"<$ARGV[2]") || die "cannot open \"$ARGV[2]\": $!"; # output__.txt is input3

my $fileName = $ARGV[2]; #BLASTxxx.txt
my $genomeID = substr($fileName,5 );#extract the XgenomeID from the filename
#extract the genomeID from the command line
for($a = 0; $a < length($genomeID); $a++){
        if(substr($genomeID, $a, 1) eq "."){
                $genomeID = substr($genomeID, 0, $a);
        }
}

#create dictionary proteinID->genomeID
my %proteinIDs;
# the input file PipeIDGenomeID
while(my $line1=<IN_PROTEINS>){
        chomp $line1;
        my @array1=split(/\t/, $line1);
        my $proteinID=$array1[0];
        my $correspondingGenomeID=$array1[1];
        $proteinIDs{$proteinID}=$correspondingGenomeID;
}
close(IN_PROTEINS);


#create array of YgenomesIDs
my @genomeIDs;
#arrayOfGenomes.txt
while(my $line2=<IN_GENOMES>){
        chomp $line2;
        my @array2= split(/\t/, $line2);
        if($array2[0] != $genomeID){
                push(@genomeIDs, $array[0]);
        }
}
close(IN_GENOMES);

#input=BLASTxxx.txt
#output=B5XXX.txt
my $nYgenomes= @genomeIDs;#number of Y genomes
my $outputFileName = "B".$genomeID.".txt";#output name
open(OUT_FILE, ">>$outputFileName");
for(my $i = 0; $i < $nYgenomes; $i++){ #go through each genome in the array
        open(IN_BLAST, "<$fileName");#open outxxx.txt
        while(my $line3 = <IN_BLAST>){#open and read line by line the outputXXX.txt for the corresponding genomeID=array[i]
                chomp $line3;
         #       if($genomeID==189){print "$fileName\t $line3\n";}
                my @array3 = split(/\t/, $line3);
                if($proteinIDs{$array3[0]} == $genomeID && $proteinIDs{$array3[1]} == $genomeIDs[$i]){#if refProtein=xGenome and yProtein=currentGenomeY)
                                #3 columns in the file:
                                print OUT_FILE "$line3\t";#refProtein yProtein evalue
                                print OUT_FILE "$proteinIDs{$array3[0]}\t";#XgenomeID

                                print OUT_FILE "$proteinIDs{$array3[1]}\n";#YgenomeID
                        }
                }
        }
        close(IN_BLAST);
}
close(OUT_FILE);

system("perl chooseBest.pl"." $outputFileName $ARGV[1]");
# $ARGV[1] is arrayOfGenomes.txt
