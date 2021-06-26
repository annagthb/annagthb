#!/usr/bin/perl
#based on Ahmed's idea ( a last year student)
#idea=          produces 3 outputs: 1(), 2(sort according to X proteins), 3(best evalue for each x protein)
#input=         addedGenomes.txt
#               arrayOfGenomes.txt
#output=        bestXXX.txt
#previous=      stepB5.pl
#successor=     takeLog2.pl


use strict;
use warnings;

open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";
my $fileName = substr($ARGV[0], 2);
my $genomeID;
for(my $a = 0; $a < length($fileName); $a++){#extract the genomeID
        if(substr($fileName, $a, 1) eq "."){
                $genomeID= substr($fileName, 0, $a);
        }
}

my $outFile = "best".$genomeID.".txt";
open(OUTPUT, ">>$outFile") || die "$!\n";

my @interactions;
while(<IN_BLAST>){
        chomp;
        push @interactions, [ split /\t/ ];
}

#sort the interactions
my @sorted;
@sorted = sort { $a->[0] <=> $b->[0] } @array;

my $evalue=$sorted[0][2];
my $xProtein=$sorted[0][0];
my $yProtein$sorted[0][1];
my $sizeOfSorted = @sorted;
for(my $row = 0; $row < @sorted-1; $row++){
        if($sorted[$row][0] == $sorted[$row+1][0] && $sorted[$row][4] == $sorted[$row+1][4] && $evalue < $sorted[$row+1][2]){#not best
                $evalue = $sorted[$row+1][2];
                $xProtein = $sorted[$row+1][0];
                $yProtein= $sorted[$row+1][1];
                next;
        }
        elsif($sorted[$row][0] == $sorted[$row+1][0] && $sorted[$row][4] != $sorted[$row+1][4]){
                print OUTPUT "$xProtein\t$yProtein\t$evalue\t$sorted[$row][4]\n";#x,y,e,Y
                $evalue = $sorted[$row+1][2];
                $xProtein = $sorted[$row+1][0];
                $yProtein = $sorted[$row+1][1];
                next;
        }
        elsif($sorted[$row][0] != $sorted[$row+1][0]){
                print OUTPUT "$xProtein\t$yProtein\t$evalue\t$sorted[$row][4]\n";
                $evalue = $sorted[$row+1][2];
                $index1 = $sorted[$row+1][0];
                $index2 = $sorted[$row+1][1];
                next;
        }
}

print OUTPUT "$sorted[$sizeOfSorted-1][0]\t$sorted[$sizeOfSorted-1][1]\t$sorted[$sizeOfSorted-1][2]\t$sorted[$sizeOfSorted-1][4]\n";

close(IN_BLAST);
close(OUTPUT);

system("perl takeLog.pl"." $outFile $genomeID $ARGV[1]");
# $ARGV[1] is arrayOfGenomes.txt
