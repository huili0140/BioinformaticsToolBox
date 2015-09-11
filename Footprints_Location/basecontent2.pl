#!/usr/bin/perl
## only suit for 
if (@ARGV!=2) {
    die "usage: perl $0 fasta.fa output\n";
}
open (I,"$ARGV[0]") || die "$!";
while (<I>) {
    chomp;
    if (/\>chrK12:(\d+)-(\d+)/) {
	$name="chrK12:".$1."-".$2;
	$hash{$1}=$name;
    }
    else {
    	$seq{$name}.=$_;
    }
}
close I;
open (O,">$ARGV[1]") || die "$!";
$TOTAL=$AA=$TT=$GG=$CC=$NN=$OO=0;
print O "Name\tTotal\tA\tT\tG\tC\tN\tOther\n";
foreach $name (sort {$a<=>$b}(keys %hash) ) {
    $total=$A=$T=$G=$C=$N=$O=0;
    @aa=split (//,$seq{$hash{$name}});
    foreach $w (@aa) {
        if ($w eq "A" || $w eq "a") {
	    $A++;
	    $AA++;
	}
        elsif ($w eq "T" || $w eq "t") {
	    $T++;
	    $TT++;
	}
        elsif ($w eq "G" || $w eq "g") {
            $G++;
	    $GG++;
        }
	elsif ($w eq "C" || $w eq "c") {
            $C++;
	    $CC++;
        }
	elsif ($w eq "N" || $w eq "n") {
	    $N++;
	    $NN++;
	}
	else {
	    $O++;
	    $OO++;
	}
    }
    $total=@aa;
    $TOTAL+=@aa;
    print O "$hash{$name}\t$total\t$A\t$T\t$G\t$C\t$N\t$O\n";
}
print O "totalinall\t$TOTAL\t$AA\t$TT\t$GG\t$CC\t$NN\t$OO\n";
close O;

