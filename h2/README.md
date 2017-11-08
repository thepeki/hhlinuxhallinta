# Harjoitus 2
### Live Xubuntu setup skripti
Aloitetaan skriptaamalla all-in-one setup xubuntu livetikulle. Tarkotus olisi automatisoida komennot jotka muuten kirjoitetaan joka live-usb bootin yhteydessä. Ensimmäinen ideani tähän tarkoitukseen on hyvin lyhyt skripti joka asettaa näppäimistön layoutin suomalaiseksi, tekee apt-get updaten ja asentaa puppetin ja gitin. Apt-get upgraden jätän vielä ainakin toistaiseksi pois, koska monessa tilanteessa se ei joko ole elintärkeä tai huono yhteys hidastaisi skriptiä huomattavasti. On myös mahdollista että luokkatilassa massoittain suoritetut apt-get kutsut onnistuvat pääsemään jäähylistalle, joten rajoitetaan niitä mahdollisuuksien mukaan.
~~~~
#!/bin/bash

#xubuntu 16.04 live USB setup script by a peki

setxkbmap fi

sudo apt-get update

sudo apt-get -y install git puppet
~~~~

Näillä asetuksilla minä olen tottunut selviämään, mutta tämä ei vielä toimi harjoitustyönä linuxin hallintaan. Seuraavaksi olisi kiva lisätä jotain puppettia skriptiin, sillä sitähän me olemme opettelemassa. Minulla pyörii RaspberryPi huoneen nurkassa, joten ajattelin että olisi kiva testata kuinka mahtava Master pienestä vatukasta saadaan aikaan. Asennetaan puppet, puppetmaster ja varmistetaan että git löytyy myös. Katsotaan mitkä versiot puppetista löytyy xubuntun listoilta ja vanhalle raspille.
~~~~
sudo puppet resource package puppet
~~~~
~~~~
package { 'puppet':
  ensure => '3.8.5-2ubuntu0.1',
}
~~~~
~~~~
package { 'puppet':
  ensure => '2.7.23-1~deb7u4',
}
~~~~
Pahaltahan se näyttää, opettajamme on aina uhonnut ettei ison numeron vaihtuessa tuppaa järjestelmät toimimaan keskenään. Ja olemme nyt opetelleet 3.* version puppettia. Mutta minähän en koskaan ole ollut hyvä oppilas, joten pakkohan sitä on kuitenkin kokeilla.