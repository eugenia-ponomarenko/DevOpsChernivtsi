#!/bin/bash

file1='/etc/passwd'
shell='/bin/bash'
use_bash=$(cat $file1 | grep $shell | cut -f1 -d:)

echo "Display a list of system users who use the Bash shell:"

echo "$use_bash"

echo -e "\nNo. of README files contains in home directory, not including the 'README.a_string' file type: "
find ~ -name *README* | grep -vc *README.a_string*




