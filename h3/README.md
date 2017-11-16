# H3
#### Tehtävänä asentaa useita orjia yhdelle masterille. 

Käytössä Xubuntu 16.04.3 live USB, jolle olisi tarkoitus asentaa pari kappaletta Vagrant Ubuntu orjia. Aluksi masterille tarvittavat lelut:
~~~~
sudo apt-get update && sudo apt-get -y install git tree puppet puppetmaster vagrant virtualbox
~~~~
Tehdään vagrantille provisioning-filu, ottaen mallia opettajan esimerkistä: http://terokarvinen.com/2017/provision-multiple-virtual-puppet-slaves-with-vagrant

~~~~
$script = <<SCRIPT
echo "I am provisioning..."
apt-get update
apt-get -y install puppet
grep ^server /etc/puppet/puppet.conf || echo -e "\n[agent]\nserver=thepekimaster\n" |sudo tee -a /etc/puppet/puppet.conf
grep thepekimaster /etc/hosts || echo -e "\n192.168.0.100 thepekimaster\n"|sudo tee -a /etc/hosts
puppet agent --enable
service puppet restart
echo -n "I am done at "
hostname
SCRIPT

Vagrant.configure(2) do |config|

  config.vm.box = "bento/ubuntu-16.04"
  config.vm.provision "shell", inline: $script
  
  
 config.vm.define "orjatar01" do |orjatar01|
 orjatar01.vm.hostname = "orjatar01"
 end
 
 config.vm.define "orjatar02" do |orjatar02|
 orjatar02.vm.hostname = "orjatar02"
 end
  
end
~~~~

Xubuntu käynnisti masterin asennuksen yhteydessä ja loi sille certit xubuntu default hostnamen alle. Suljetaan puppetmaster palvelu, poistetaan certit, asetetaan uusi hostname ja käynnistetään puppetmaster uusiksi luoden uudet certit uudelle nimelle.

~~~~
sudo service puppetmaster stop
sudo rm -rv /var/lib/puppet/ssl
sudoedit /etc/puppet/puppet.conf
~~~~
Lisätään masterin alle
~~~~
dns_alt_names = thepekimaster, thepekimaster.local
~~~~
Ja käynnistetään puppetmaster uudestaan.
~~~~
sudo service puppetmaster start
sudo openssl x509 -in /var/lib/puppet/ssl/certs/xubuntu.kinnaridlink.pem  -text|grep -i dns
~~~~
Joka tulostaa...
~~~~
DNS:thepekimaster, DNS:thepekimaster.local, DNS:xubuntu.kinnaridlink
~~~~
Kaikki siis näyttäisi olevan kunnossa. Sitten ajetaan vagrantit ja toivotaan parasta.
~~~~
cd vagrant/
vagrant up
~~~~
Boom.
~~~~
Bringing machine 'orjatar01' up with 'virtualbox' provider...
Bringing machine 'orjatar02' up with 'virtualbox' provider...
==> orjatar01: Box 'bento/ubuntu-16.04' could not be found. Attempting to find and install...
    orjatar01: Box Provider: virtualbox
    orjatar01: Box Version: >= 0
==> orjatar01: Loading metadata for box 'bento/ubuntu-16.04'
    orjatar01: URL: https://atlas.hashicorp.com/bento/ubuntu-16.04
==> orjatar01: Adding box 'bento/ubuntu-16.04' (v201710.25.0) for provider: virtualbox
    orjatar01: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-16.04/versions/201710.25.0/providers/virtualbox.box
==> orjatar01: Successfully added box 'bento/ubuntu-16.04' (v201710.25.0) for 'virtualbox'!
==> orjatar01: Importing base box 'bento/ubuntu-16.04'...
==> orjatar01: Matching MAC address for NAT networking...
==> orjatar01: Checking if box 'bento/ubuntu-16.04' is up to date...
==> orjatar01: Setting the name of the VM: vagrant_orjatar01_1510770799391_1308
==> orjatar01: Clearing any previously set network interfaces...
==> orjatar01: Preparing network interfaces based on configuration...
    orjatar01: Adapter 1: nat
==> orjatar01: Forwarding ports...
    orjatar01: 22 (guest) => 2222 (host) (adapter 1)
==> orjatar01: Booting VM...
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.

Command: ["startvm", "5c2b239b-2b3f-459a-abff-46f2493c527d", "--type", "headless"]

Stderr: VBoxManage: error: VT-x is disabled in the BIOS for all CPU modes (VERR_VMX_MSR_ALL_VMX_DISABLED)
VBoxManage: error: Details: code NS_ERROR_FAILURE (0x80004005), component ConsoleWrap, interface IConsole

~~~~
Error message googleen ja vastauksia etsimään. Eka osuma sanoo ettei CPU tue virtualisaatiota kertoo asentamaan cpu-checker:in ja katsomaan sillä voiko asialle tehdä jotain.
~~~~
sudo apt-get -y install cpu-checker
~~~~
Ja sehän kertoo että virtualisaatio on pois päällä BIOS asetuksissa.
~~~~
xubuntu@xubuntu:~$ sudo kvm-ok 
INFO: /dev/kvm does not exist
HINT:   sudo modprobe kvm_intel
INFO: Your CPU supports KVM extensions
INFO: KVM (vmx) is disabled by your BIOS
HINT: Enter your BIOS setup and enable Virtualization Technology (VT),
      and then hard poweroff/poweron your system
KVM acceleration can NOT be used
~~~~
Päätän, että pitänee testata toisessa ympäristössä lisää...

#### Labrassa uusintatesti

Ajetaan sama ympäristö, vaihtaen IP osoite. Menee läpi onnistuneesti. Varmistetaan toiminta hellopeki moduulilla site.pp filessä.
Moduuli luo onnistuneesti hello-viestin /tmp/ kansioon kummallekin orjalle.

~~~~
$ sudo puppet cert list -a
+ "orjatar01.tielab.haaga-helia.fi" (SHA256) 2C:C5:5A:FE:B4:A9:05:D9:9E:5C:9E:10:CF:AB:1B:AF:0F:CA:5C:1A:18:68:1D:7D:40:0C:6D:E8:CF:46:E2:1D
+ "orjatar02.tielab.haaga-helia.fi" (SHA256) 86:98:A7:27:08:D9:35:21:52:55:E7:96:46:B0:B6:76:A1:66:1C:54:A1:E9:00:8D:87:EA:66:B5:1B:EF:9D:07
+ "xubuntu.tielab.haaga-helia.fi"   (SHA256) 65:91:9F:59:14:EE:F7:46:F3:A0:93:FD:AF:BA:C2:5A:1F:AB:38:DA:B1:8C:1A:B1:BD:D7:F4:BB:05:6D:CB:1C (alt names: "DNS:thepekimaster", "DNS:thepekimaster.local", "DNS:xubuntu.tielab.haaga-helia.fi")

~~~~
