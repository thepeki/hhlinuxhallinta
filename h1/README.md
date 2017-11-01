# teht 1

Asennetaan puppetti apt-get update tehtynä
_sudo apt.get -y install puppet_

tarkastetaan onko läppärillä jo ssh demoni
_service --status-all_

shh löytyy ja on pystyssä. Tarkastetaan mitä puppetti kertoo siitä.
_sudo puppet resource service ssh_

Puppetti listaa vain _ensure => 'running'_
