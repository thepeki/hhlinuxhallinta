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
