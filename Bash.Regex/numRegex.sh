#!/bin/sh

regex="(\+38)?\(?(03)[1-8]{1}\)?[1-8]{3}[ .-]?[0-9]{2}[ .-]?[0-9]{2}"

echo "Enter phone number:"

read num

(echo "$num" | grep -Eq "$regex") && echo "This is the phone number of Western Ukraine" || echo "This is not the phone number of Western Ukraine"
