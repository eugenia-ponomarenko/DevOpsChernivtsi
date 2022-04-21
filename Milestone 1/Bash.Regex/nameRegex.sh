#!/bin/sh

regex3="((Євге)[нш]{1}[іа]{1}[яєюї]{0,1}[ю]{0,1})|((Жен)[яієь]{1}[ючк]{0,1}[каои]{0,1}[аіою]{0,1}[ю]{0,1})"

echo "Enter you name in Ukrainian:"

read name

(echo "$name" | grep -Eq "$regex3") && echo "Coincides with regex" || echo "Do not match with regex"