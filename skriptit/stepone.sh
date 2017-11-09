#!/bin/bash

#Step one script by a peki

#setxkbmap fi

echo -n "How many virtual machines will we create today?"
read number

#sudo apt-get update

#sudo apt-get -y install vagrant virtualbox

for (( i=0;i<number;i++ ))
do
	mkdir -p vagrantslaves/slave-$i
done
