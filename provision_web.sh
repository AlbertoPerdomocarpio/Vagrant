#!/bin/bash

# Aggiornamento del sistema
sudo apt-get update -y

# Installazione di Apache e PHP esentioni
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql php-mysqli

# Abilitazione e avvio di Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# Installazione di Adminer per gestione database
sudo mkdir -p /var/www/html/adminer
sudo wget -q -O /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# Impostazione dei permessi
sudo chown -R www-data:www-data /var/www/html

# Riavvio di Apache per assicurarsi che tutte le modifiche siano attive
sudo systemctl restart apache2
