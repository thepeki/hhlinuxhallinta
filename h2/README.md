#Harjoitus 2
Aloitetaan skriptaamalla all-in-one setup xubuntu livetikulle. Tarkotus olisi automatisoida komennot jotka muuten kirjoitetaan joka live-usb bootin yhteydessä. Ensimmäinen ideani tähän tarkoitukseen on hyvin lyhyt skripti joka asettaa näppäimistön layoutin suomalaiseksi, tekee apt-get updaten ja asentaa puppetin ja gitin. Apt-get upgraden jätän vielä ainakin toistaiseksi pois, koska monessa tilanteessa se ei joko ole elintärkeä tai huono yhteys hidastaisi skriptiä huomattavasti. On myös mahdollista että luokkatilassa massoittain suoritetut apt-get kutsut onnistuvat pääsemään jäähylistalle, joten rajoitetaan niitä mahdollisuuksien mukaan.
~~~~
#!/bin/bash

#xubuntu 16.04 live USB setup script by a peki

setxkbmap fi

sudo apt-get update

sudo apt-get -y install git puppet
~~~~
