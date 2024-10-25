# -*- mode: ruby -*-
# vi: set ft=ruby :

# Definizione delle variabili
BOX_IMAGE = "ubuntu/jammy64"
BASE_INT_NETWORK = "10.10.20"
BASE_HOST_ONLY_NETWORK = "192.168.56"

Vagrant.configure("2") do |config|

  # Configurazione VM Web
  config.vm.define "web.m340" do |web|
    web.vm.box = BOX_IMAGE
    web.vm.hostname = "web.m340"
    
    
    # Impostazioni di rete
    web.vm.network "private_network", ip: "#{BASE_INT_NETWORK}.10", virtualbox__intnet: "intnet"
    web.vm.network "private_network", ip: "#{BASE_HOST_ONLY_NETWORK}.10", name: "VirtualBox Host-Only Ethernet Adapter"

    # Cartella condivisa per le pagine del sito
    web.vm.synced_folder "./web", "/var/www/html"

    # Provisioning con file di script per il server web
    web.vm.provision "shell", path: "provision_web.sh"
  end

  # Configurazione VM Database
  config.vm.define "db.m340" do |db|
    db.vm.box = BOX_IMAGE
    db.vm.hostname = "db.m340"
    
    # Impostazioni di rete
    db.vm.network "private_network", ip: "#{BASE_INT_NETWORK}.11", virtualbox__intnet: "intnet"

    # Provisioning con file di script per il database
    db.vm.provision "shell", path: "provision_db.sh"
  end

end
