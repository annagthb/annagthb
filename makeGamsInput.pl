#!/usr/bin/perl
#based on Ahmed's idea ( a last year student)
#idea=          creates the Gams inputs for the genome X: the set is (x proteinIds),the set js (YgenomeIDs), the parameter A(i,j)s
#input=         rmvedDominatedXX.txt
#               arrayOfGenomes.txt
#output=        gamsInputXXX.inc
#previous=      rmvDominated.pl
#successor=     runGams.pl

use strict;
use warnings;

open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";

my $inName= $ARGV[0];
my $genomeID = substr($fileName, 12);
for($i = 0; $i < length($genomeID); $i++){
        if(substr($genomeID, $i, 1) eq "."){
                $genomeID = substr($genomeID, 0, $i);
        }
}

my $outputName= "gamsInput".$genomeID.".inc";
open(OUTPUT, ">>$outputName") || die "cannot open inc.inc";

my $firstProtein= 0;
my $lastProtein = 0;
my @yGenomes;

open(IN_GENOMES, "<$ARGV[1]") || die "arrayOfGenomes.txt";
while(my $line= <IN_GENOMES>){
        chomp $line;
        my @array= split(/\t/, $line);
        if($array[0] == $genomeID){
                $firstProtein = $array[1];
                $lastProtein = $array[2];
        }
        else{
                push(@yGenomes, $array[0]);
        }
}
close(IN_GENOMES);

my @genes;
open(IN_BLAST, "<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";
my $line= <IN_BLAST>;
while($line= <IN_BLAST>){
        chomp $line;
        my @array= split(/\t/, $line);
        push(@genes, $array[0]);
}
close(IN_BLAST);

print OUTPUT "sets\n";
print OUTPUT "i  /  ";

my $nGenes= @genes;
for(my $ik = 0; $ik < $nGenes; $ik++){
        print OUTPUT "i"."$nGenes[$ik]";
        if(($ik+1) != $nGenes){
                print OUTPUT "\n";
        }
        else{
                print OUTPUT " /\n";
        }
}

print OUTPUT "j /  ";
for(my $i = 0; $i < @yGenomes; $i++){
        print OUTPUT "j"."$yGenomes[$i]";
        if($i != @yGenomes - 1){
                print OUTPUT "\n";
        }
        else{
                print OUTPUT "  /;\n";
        }
}
print OUTPUT "parameter A(i,j)/\n";

my $lineNumber = 0;
my @yGenomes;
while(my $line = <IN_BLAST>){
        chomp $line;
        if($lineNumber == 0){
               my @array= split(/\t/, $line);
                for(my $i= 0; $i < @array; $i++){
                        push(@yGenomes, $array[$i]);
                }
                $lineNumber++;
        }
        else{
                my @array2= split(/\t/, $line);
                for(my $j = 1; $j< @array2; $j++){
                        print OUTPUT "i"."$array2[0]\t";
                        print OUTPUT ".j"."$comparisonGenomes[$j]\t";
                        print OUTPUT "$array2[$j]\n";
                }
        }
}
close(IN_BLAST);
print OUTPUT "/;";
close(OUTPUT);
system("perl runGams.pl"." $outputName");
