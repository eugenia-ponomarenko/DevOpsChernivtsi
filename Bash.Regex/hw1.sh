#!/bin/bash

file1='/etc/passwd'
shell='/bin/bash'
use_bash=$(cat $file1 | grep $shell | cut -f1 -d:)

echo "\nDisplay a list of system users who use the Bash shell:"

echo "$use_bash"


file2='/etc/group'
regex='^daemon'

echo "\nOutput lines of the /etc/group file that begin with a sequence of daemon characters:"
grep "$regex" $file2

echo "\nNo. of README files contains in home directory, not including the 'README.a_string' file type: "
find ~ -name *README* | grep -vc *README.a_string*

echo "\nOutput lines of the /etc/group file that do not contain a sequence of daemon characters:"
cat $file2 | grep -v $regex

minutes=1

echo "\nA list of files in home dir that changed less than $minutes: "
find ~ -type f -mmin -$minutes



