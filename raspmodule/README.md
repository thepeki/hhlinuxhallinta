# Raspberry Pi puppet conffit

Tavoite: Raspberry Pi:n Raspbian käyttiksen uudelleen asennus ja käytössä olevien ohjelmien ja palveluiden uudelleen asennus puppet moduuleilla.

### Step 1
Määritetään mitkä paketit ja palvelut halutaan asentaa uudestaan. Listataan ne:
* irssi
* screen
* samba
* apache
* mumble
* puppet
* puppetmaster

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
On aika pistää SD-kortti palasiksi, ristiä sormet ja suorittaa muita ylemmän tahon lepyyttäviä toimenpiteitä. Ja sitten tarkastaa mikä menee vikaan.

