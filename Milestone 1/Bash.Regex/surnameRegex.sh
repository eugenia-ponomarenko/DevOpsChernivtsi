#!/bin/sh

regex="^Пономаренко$"

echo "Enter you surname in Ukrainian:"

read surname

(echo "$surname" | grep -Eq "$regex") && echo "Coincides with regex" || echo "Do not match with regex"