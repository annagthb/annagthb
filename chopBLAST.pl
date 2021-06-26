#!/usr/bin/perl
#idea chops the huge BLAST file into smaller files corresponding to each particular genome
use strict;
use warnings;
use diagnostics;
no strict 'refs';


open(IN_IDS,"<$ARGV[0]")||die"cant open \"$ARGV[0]\":$!";#input=proteinID-genomeID
open(IN_ARRAY,"<$ARGV[1]")||die"cant open \"$ARGV[1]\":$!";#input=array of Genomes
open(IN_BLAST,"<$ARGV[2]")||die"cant open \"$ARGV[2]\":$!";#input=hugeBLAST


#create an array to hold the genomes
#and create a dictionary genomeID->1
my @genomesArray;
my %genomesDictionary;
my @currentLine;
my %outs;#a dictionary genomeID->outVar
my $genomeID;
my $outName;
my $outVar;
while(my $line=<IN_ARRAY>){
        chomp $line;
        @currentLine=split(/\t/,$line);
        $genomeID=$currentLine[0];
        push(@genomesArray,$genomeID);
        $genomesDictionary{"$genomeID"}="1";

        $outName="BLAST"."$genomeID";
        $outVar="OUT_BLAST"."$genomeID";
        $outs{$genomeID}=$outVar;
        open($outs{$genomeID},">>$outName")||die"cant create \"$outName\":$!";
}
close(IN_ARRAY);

#create a dictionary proteinID->genomeID
#and extend the dictionary with the genomeIDs not found in the array. genomeID->0(because its not in the array)
my %proteins;
my $proteinID;
while(my $line=<IN_IDS>){
        chomp $line;
        @currentLine=split(/\t/,$line);
        $proteinID=$currentLine[0];
        $genomeID=$currentLine[1];
        $proteins{$proteinID}=$genomeID;
        if($genomesDictionary{$genomeID}!="1"){
                $genomesDictionary{$genomeID}="0";
        }
}
close(IN_IDS);

#go through BLAST and write out the smaller BLASTS
my $xProtein;
my $yProtein;
my $eValue;
my $k=1;
while(my $line=<IN_BLAST>){
        print "$k\n";#to have a clue how far the program has gone
        $k=$k+1;
        chomp $line;
        @currentLine=split(/\t/,$line);
        $xProtein=$currentLine[0];
        $yProtein=$currentLine[1];
        $eValue=$currentLine[10];
        $genomeID=$proteins{$xProtein};
        if($genomesDictionary{"$genomeID"}=="1" && $eValue!=0){
                        print {$outs{$genomeID}} "$xProtein\t$yProtein\t$eValue\n";
                }
}
close(IN_BLAST);

#for each Xgenome call the next programs in the pipeline
for(my $i=0;$i<@genomesArray;$i++){
        $genomeID=$genomesArray[$i];
        $outName="BLAST"."$genomeID";
        close($outs{$genomeID});
        system("perl addGenomeIDs.pl"." $ARGV[0] $ARGV[1] $outName");
}
