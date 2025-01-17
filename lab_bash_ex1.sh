#!/bin/bash

#Make a new directory called "students" in your home and get in
#mkdir $HOME/students
cd $HOME/students

#Check whether the file is already there
if [ -e "/home/pira/students/LCP_22-23_students.csv" ]; then
  echo "The file already exists"
else
  echo "The file doesn't exist. Let's to download it!"
  #Download a csv file with the list of students of this lab and copy that to students
  wget -O LCP_22-23_students.csv "https://www.dropbox.com/scl/fi/bxv17nrbrl83vw6qrkiu9/LCP_22-23_students.csv?rlkey=47fakvatrtif3q3qw4q97p5b7&e=1"
fi

#Make two new files, one containing the students belonging to PoD, the other to Physics.
grep "PoD"  LCP_22-23_students.csv > LCP_22-23_students_PoD.csv
grep "Physics" LCP_22-23_students.csv > LCP_22-23_students_Physics.csv

#For each letter of the alphabet, count the number of students whose surname starts with that letter.
count_list=()
letter_list=()

for letter in {A..Z}; do
  count=$(grep -c "^$letter" "/home/pira/students/LCP_22-23_students.csv")
  count_list+=($count)  #store the counts in a list
  letter_list+=($letter)  #store the letters in a list
  echo "$letter: $count"
 done

#Find out the most recurrent letter
for ((i=1; i<=${#count_list[@]}; i++)); do
  if [[ ${count_list[i]} -gt $max ]]; then
    max=${count_list[i]}
    max_l=${letter_list[i]}
  fi
done

#Print out the mostrecurrent surname's initial letter
echo "The most recurrent letter is: $max_l"

#Assume an obvious numbering of the students in the file (first line is 1,
#second line is 2, etc.), group students "modulo 18", i.e. 1,19,37,.. 2,20,38,.. etc.
#and put each group in a separate file
# First eliminate the first line of the file
sed -i '1d' LCP_22-23_students.csv
for (( i=0; i<=17; i++ )); do
  awk "NR%18==$i" "LCP_22-23_students.csv" > modulo18_group_$i.txt
done
