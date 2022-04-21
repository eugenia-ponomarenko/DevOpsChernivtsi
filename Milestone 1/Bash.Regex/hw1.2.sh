#!/bin/bash


file2='/etc/group'
regex='^daemon'

echo "Output lines of the /etc/group file that begin with a sequence of daemon characters:"
grep "$regex" $file2

echo -e "\nOutput lines of the /etc/group file that do not contain a sequence of daemon characters:"
cat $file2 | grep -v $regex

echo -e "\nNo. of lines of the /etc/group file that do not contain a sequence of daemon characters:"
cat $file2 | grep -vc $regex



