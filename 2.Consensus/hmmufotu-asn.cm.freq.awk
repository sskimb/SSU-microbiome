BEGIN {total=0; p1=0; p2=0; p3=0; p4=0}
{total += $2; p1 += $3; p2 += $4; p3 += $5; p4 += $6}
END {print (p1+p2+p3+p4)/total}
