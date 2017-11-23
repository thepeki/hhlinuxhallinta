#!/bin/bash

#xubuntu 16.04 live USB setup script by a peki

setxkbmap fi
alias ux='chmod ugo+x'

sudo apt-get update

sudo apt-get -y install git puppet puppetmaster tree

grep thepekimaster /etc/hosts || echo -e "127.0.0.1 thepekimaster\n" >> /etc/hosts
