#!/bin/bash

#Make a copy of the file data.csv removing the metadata and the commas between numbers
#call it data.txt
sed -e 's/,//g' -e '/^#/d' data.csv > data.txt

#How many even numbers are there?
awk '{for(i=1;i<=NF;i++){if($i%2==0) even_numbers++}} END{print even_numbers}' data.txt

#Distinguish the entries on the basis of sqrt(X^2 + Y^2 + Z^2) is greater or smaller than 100*sqrt(3)/2. Count the entries of each of the two groups
threshold=$(bc <<< "scale=2; 100*sqrt(3)/2")

less=0
greater=0

while read line; do
  x=$(echo "$line" | cut -d ' ' -f1)
  y=$(echo "$line" | cut -d ' ' -f2)
  z=$(echo "$line" | cut -d ' ' -f3)
  d=$(bc <<< "scale=2; sqrt($x*$x + $y*$y + $z*$z)")

  if (( $(bc <<< "$d <= $threshold") )); then
    ((less++))
  else
    ((greater++))
  fi

done < "data.txt"

echo "The number of points under the threshold distance are: $less"
echo "The number of points under the threshold distance are: $greater"
