#!/bin/bash
. functions.include

for mail in ../data/*/
do
	mail="$(basename $mail)"
	storesfile="../data/${mail}/stores"
	echo "$(timestamp)|mail:$mail|stores file: $storesfile"
	./createstores.sh "$mail" > "$storesfile"
done

