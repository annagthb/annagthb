$INCLUDE makeInc.inc

variables
w(j)
epsilon;
positive variable w(j);

display A;

equations
cons1
obj(i);
cons1.. sum(j,w(j))=e= 1;
obj(i).. sum((j),A(i,j)*w(j)) =g= epsilon;

model weights /ALL/;
solve weights using lp maximizing epsilon;

file output / output.txt /;
put output;

loop(j,put @1,j.tl,@10,put w.l(j):8:4/);

file epsi_value /epsi_value.txt/;
put epsi_value;
put epsilon.l;
