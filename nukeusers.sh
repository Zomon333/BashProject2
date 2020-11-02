#!/bin/bash

function getName()
{
	echo $1 | cut --delimiter=@ -f 1
}

while read line
do
	USER=$(getName $line)
	deluser --remove-home $USER
done <"emails.txt"
