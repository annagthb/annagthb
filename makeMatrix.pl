#!/usr/bin/perl
#idea=		convert to matrix format
#input=         sortedXXX.txt (or OPXXX.txt an paravlepsoume to deleteNulls.pl)
#               arrayOfGenomes.txt
#output=        matrixXXX.txt
#previous=      sortCells.pl
#successor=     rmvSames.pl



use strict;
use warnings;

#find the genomeID
open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";#makeAnotherInc2XXX.txt
my $inputName= $ARGV[0];

my $genomeID=substr($fileName,2);
for($a = 0; $a < length($genomeID); $a++){
        if(substr($genomeID, $a, 1) eq "."){
                $genomeID = substr($genomeID, 0, $a);
        }
}

my $outName = "matrix".$genomeID.".txt";
open(OUTPUT, ">>$outName") || die "cannot open inc.inc";

my $counter = 0;
my $firstColumn = 0;
my $nGenomes;
my @genomesIDs;
sub exists{
        my $result = 0;
        if(@genomesIDs == 0){
                return $result;
        }
        else{
                for(my $i = 0; $i < @genomesIDs; $i++){
                        if($genomesIDs[$i] == $_[0]){
                                $result= 1;
                        }
                }
                return $result;
        }
}

while(my $line = <IN_BLAST>){
        chomp $line;
        my @array = split(/\t/, $line);
        if(exists($array[1]) == 0){
                push(@genomesIDs, $array[1]);
        }
        else {
                last;
        }
}
close(IN_BLAST);



print OUTPUT "\t";

for(my $i = 0; $i < @genomesIDs; $i++){
        print OUTPUT "$genomes[$i]\t";
}
print OUTPUT "\n";


open(IN_BLAST,"<$ARGV[0]") || die "cannot open \"$ARGV[0]\": $!";
while(my $line = <IN_BLAST>){
        chomp $line;
        my @array = split(/\t/, $line);
        if($counter == 0){
                print OUTPUT "$array[0]"."\t"."$array[2]";
                $firstColumn = $array[0];
                $counter++;
        }
        elsif($firstColumn == $array[0]){
                print OUTPUT "\t"."$array[2]";
        }
        elsif($firstColumn != $array[0]){
                $firstColumn = $array[0];
                print OUTPUT "\n";
                print OUTPUT "$array[0]"."\t"."$array[2]";
        }
}
close(IN_BLAST);
close(OUTPUT);

system("perl rmvSames.pl"." $outputFileName $ARGV[1]");
# $ARGV[1] is arrayOfGenomes.txt
