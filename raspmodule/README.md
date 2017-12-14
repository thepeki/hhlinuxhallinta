# Raspberry Pi puppet conffit

Tavoite: Raspberry Pi:n Raspbian-käyttiksen uudelleenasennus ja käytössä olevien ohjelmien ja palveluiden uudelleenasennus puppet moduuleilla.

### Step 1
Määritetään mitkä paketit ja palvelut halutaan asentaa uudestaan. Listataan ne:
* irssi
* screen
* samba
* apache
* mumble
* puppet
* puppetmaster
* git

### Step 2
Tarkistin onko kotihakemistossa mitään asetustiedostoja mitä haluan talteen. 
* Löysin irssin conf-filen, otin kuitenkin koko kansion talteen. ~/.irssi

### Step 3
Kurkataan /etc/ sisälle ja katsotaan onko siellä mitään elintärkeää.
* Samban asetustiedosto tarttui matkaan. /etc/samba/smb.conf
* Mumblea en ole käyttäny vuosiin ja siihen on ollut muilla ainakin softan sisäisiä hallintaoikeuksia joten tyydyn puhtaaseen asennukseen ainakin aluksi.
* sshd asetuksista olen vaihtanut portin numeron, en ota tiedostoa sitä varten talteen.
* apache saa niin ikään olla vielä perusasetuksillaan, koska mitään sivuja se ei tällä hetkellä tarjoile.

### Step 4
On aika pistää SD-kortti palasiksi, ristiä sormet ja suorittaa muita ylemmän tahon lepyyttäviä toimenpiteitä. Ja sitten tarkastaa mikä menee vikaan. [Raspberrypi.org ohjeilla.](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

### Step 5
Raspin konffit kuntoon. Näyttö ja näppis kiinni itse laitteeseen, ei verkkoon vielä tässä vaiheessa.
* Pi käyttäjän passu vaihtoon - **sudo passwd**
* Raspin omasta all-in-one-konffista lokalisaatiot, ssh demoni päälle, SD-kortin partition allokaatiot kohdilleen ja restart - **sudo raspi-config**
* Uusi käyttäjä - **sudo adduser**
* Uusi käyttäjä sudo ryhmään - **sudo adduser nimi sudo**
* Kirjaudutaan ulos Pi ja sisään omalla, testataan että uudella käyttäjällä tosiaan oikeudet sudoilla - **sudo whoami && sudo visudo**
* Pistetään Pi-käyttäjä pannaan - sudo passwd pi -l
* Vaihdetaan sshd default portista omaan super-sekret numeroon - sudoedit /etc/ssh/sshd_config
* Restartataan sshd - sudo service ssh restart
* Kytketään laite verkkoon ja nautitaan loput konffailut päättömälle palvelimelle.
* Logataan sisään uudella käyttäjällä ja ajetaan update - sudo apt-get update

### Step 6
* Asennetaan puppet ja puppetmaster - **sudo apt-get -y install puppet puppetmaster**
~~~~
● puppet-master.service - Puppet master
   Loaded: loaded (/lib/systemd/system/puppet-master.service; enabled; vendor preset: enabled)
   Active: failed (Result: timeout) since Thu 2017-12-14 04:29:32 EET; 27s ago
     Docs: man:puppet-master(8)
  Process: 247 ExecStart=/usr/bin/puppet master (code=exited, status=1/FAILURE)

Dec 14 04:27:43 raspberrypi systemd[1]: Starting Puppet master...
Dec 14 04:29:32 raspberrypi systemd[1]: puppet-master.service: Start operation timed out. Terminating.
Dec 14 04:29:32 raspberrypi puppet-master[247]: Could not run: SIGTERM
Dec 14 04:29:32 raspberrypi systemd[1]: puppet-master.service: Control process exited, code=exited status=1
Dec 14 04:29:32 raspberrypi systemd[1]: Failed to start Puppet master.
Dec 14 04:29:32 raspberrypi systemd[1]: puppet-master.service: Unit entered failed state.
Dec 14 04:29:32 raspberrypi systemd[1]: puppet-master.service: Failed with result 'timeout'.
~~~~
Google-fu taidoilla ei löydy syitä miksi puppetmaster epäonnistuu, päätän pudottaa masterin osuuden raspilta ja kokeilla pelkän orjan roolia.



