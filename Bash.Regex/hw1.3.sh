#!/bin/bash

minutes=1

echo "A list of files in home dir that changed less than $minutes: "
find ~ -type f -mmin -$minutes

echo -e "\nNo. of files in home dir that changed less than $minutes: "
find ~ -type f -mmin -$minutes | wc -l
