# Harjoitus 2
### Live Xubuntu setup skripti
Aloitetaan skriptaamalla all-in-one setup xubuntu livetikulle. Tarkotus olisi automatisoida komennot jotka muuten kirjoitetaan joka live-usb bootin yhteydessä. Ensimmäinen ideani tähän tarkoitukseen on hyvin lyhyt skripti joka asettaa näppäimistön layoutin suomalaiseksi, tekee apt-get updaten ja asentaa puppetin ja gitin. Apt-get upgraden jätän vielä ainakin toistaiseksi pois, koska monessa tilanteessa se ei joko ole elintärkeä tai huono yhteys hidastaisi skriptiä huomattavasti. On myös mahdollista että luokkatilassa massoittain suoritetut apt-get kutsut onnistuvat pääsemään jäähylistalle, joten rajoitetaan niitä mahdollisuuksien mukaan.
~~~~
#!/bin/bash

#xubuntu 16.04 live USB setup script by a peki

setxkbmap fi

sudo apt-get update

sudo apt-get -y install git puppet tree
~~~~

Näillä asetuksilla minä olen tottunut selviämään, mutta tämä ei vielä toimi harjoitustyönä linuxin hallintaan. 
### Master of the puppets
Seuraavaksi olisi kiva lisätä jotain puppettia skriptiin, sillä sitähän me olemme opettelemassa. Minulla pyörii RaspberryPi huoneen nurkassa, joten ajattelin että olisi kiva testata kuinka mahtava Master pienestä vatukasta saadaan aikaan. Asennetaan puppet, puppetmaster ja varmistetaan että git löytyy myös. 
~~~~
sudo apt-get update && sudo apt-get -y install puppet puppetmaster git
~~~~
Katsotaan mitkä versiot puppetista löytyy xubuntun listoilta ja vanhalle raspille.
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
Pahaltahan se näyttää, opettajamme on aina uhonnut ettei ison numeron vaihtuessa tuppaa järjestelmät toimimaan keskenään. Ja olemme nyt opetelleet 3.* version puppettia. Mutta minähän en koskaan ole ollut hyvä oppilas, joten pakkohan sitä on kuitenkin kokeilla. Testataan ekaksi toimiiko H1 ssh moduuli jonka teimme viime viikolla.
~~~~
git clone https://github.com/thepeki/hhlinuxhallinta.git

sudo puppet apply --modulepath hhlinuxhallinta/h1/puppet/modules/ -e 'class {"ssh":}'
~~~~
RaspberryPi:lläni on jo sshd ja yllä oleva komento näyttäisi onnistuvan ongelmitta. So far so good. *notice: Finished catalog run in 1.71 seconds*

Seuraavaksi kerrataan tunnilla käytyjä puppetmasterin asetuksia sivulta: http://terokarvinen.com/2012/puppetmaster-on-ubuntu-12-04

Koska olen lähiverkossa kummallakin testilaitteellani, asennetaan avahi palvelemaan lokaalina dns palvelimena. Ja editoidaan conffeja jotta .local osoitteet toimivat. +Restartataan:
~~~~
sudo apt-get -y install avahi-utils
sudoedit /etc/avahi/avahi-daemon.conf
sudo service avahi-daemon restart
~~~~
Lisätään dns_alt_names masterin puppet.confiin & restartataan
~~~~
[master]
...
dns_alt_names = vatukka.local
~~~~
~~~~
sudo service puppetmaster restart
~~~~
Lisätään *agentille* (Lue: orja) server ja restartataan:
~~~~
[agent]
server = vatukka.local
sudo service puppet restart
~~~~
Ja ihaillaan masterilla (toivottavasti) uutta certtiä puppetin listoissa.
~~~~
sudo puppet cert --list
  "thepeki-hp-655-notebook-pc.kinnaridlink" (xx:xx..:xx)
~~~~
Ja jos orjamme löytyy kuten yllä voimme värvätä sen nousevan masterin palvelukseen.
~~~~
sudo puppet cert --sign thepeki-hp-655-notebook-pc.kinnaridlink
~~~~
~~~~
notice: Signed certificate request for thepeki-hp-655-notebook-pc.kinnaridlink
notice: Removing file Puppet::SSL::CertificateRequest thepeki-hp-655-notebook-pc.kinnaridlink at '/var/lib/puppet/ssl/ca/requests/thepeki-hp-655-notebook-pc.kinnaridlink.pem'
~~~~
#### Success!
Laitetaan helloworld-vastaava moduuli ja includataan se masterin site manifestiin:
~~~~
class hellopeki {
	file { '/tmp/hellopekipuppet':
		content => "Obey your master!",
	}
}
~~~~
~~~~
sudo cp -rv hellopeki/ /etc/puppet/modules/
~~~~
~~~~
sudoedit /etc/puppet/manifests/site.pp
~~~~
~~~~
include hellopeki
~~~~
Koska ei viitsi odotella 30min jotta näemme onnistuiko hellopeki, restarttaamme orjan puppet servicen vielä kertaalleen.
~~~~
sudo puppet agent --enable
sudo service puppet restart
cat /tmp/hellopekipuppet
~~~~
Ei toiminut ekalla kerralla. Katsotaan mitä masterin logit kertoo. hellopeki toimii locaalisti.
~~~~
sudo puppet cert list --all
~~~~
~~~~
+ "thepeki-hp-655-notebook-pc.kinnaridlink" (87:?????????????????????????????????????????:B1)
+ "vatukka.kinnaridlink"                    (2A:?????????????????????????????????????????:4F) (alt names: "DNS:puppet", "DNS:puppet.kinnariDlink", "DNS:vatukka.kinnariDlink", "DNS:vatukka.kinnaridlink")
~~~~
#### Ei nuolaista ennen kuin tipahtaa
Onnistuin siis listaamaan orjan, kaikki näyttäisi olevan kunnossa ja orja päällä. Mutta jostain toistaiseksi tuntemattomasta syystä site manifestia ei suoriteta orjalla. Täytyy mahdollisuuksien mukaan testata saman version puppeteilla josko olisi yhteensopimattomuudesta kyse.
