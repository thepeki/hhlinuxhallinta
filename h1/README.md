# teht 1

Asennetaan puppetti apt-get update tehtynä

_sudo apt-get -y install puppet_

Asetetaan puppetille ordering manifests

_sudoedit /etc/puppet/puppet.conf_

Editoidaan sinne [main] kohdan alle _ordering = manifest_

tarkastetaan onko läppärillä jo ssh demoni

_service --status-all_

shh löytyy ja on pystyssä. Tarkastetaan mitä puppetti kertoo siitä.

_sudo puppet resource service ssh_

Puppetti listaa vain _ensure => 'running'_

Luodaan puppet module ssh, toistaiseksi kotikansioon. Ja sinne init.pp

_mkdir -p puppet/modules/ssh/manifests_

_touch puppet/modules/ssh/manifests/init.pp_

Kirjoitetaan perus ssh moduuli jossa ensure running ja enable true servicelle ja
ensure installed ja allowcdrom true packagelle openssh-server.

Ajetaan testi:

_sudo puppet apply --modulepath modules/ -e 'class {"ssh":}'_

Korjataan kirjoitusvirheet error ilmoituksesta, koitetaan uudestaan ja onnistutaan 
toisella kerralla! Tylsä testi koska ssh oli jo asennettuna. Uhmataan kohtaloa
poistamalla openssh-server ja yritetään uudestaan.

_sudo apt-get -y remove openssh-server_

Todetaan ssh puuttuvaksi, jota se tosin ei ole ainakaan service --status-all listalla.
Ssh näkyy listalla miinuksena. 
Oletan että se johtuu ssh clientin läsnäolosta. Openssh-server paketti on 'absent'.

Ajetaan moduulimme ja tarkastellaan uudelleen: 

Paketti löytyy versiona _'1:7.2p2-4ubuntu2.2'_

ja service on saanu + merkin  _[ + ]  ssh_
