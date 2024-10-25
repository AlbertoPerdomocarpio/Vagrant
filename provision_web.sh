#!/bin/bash

# Aggiornamento del sistema
apt-get update -y

# Installazione di Apache e PHP esentioni
apt-get install -y apache2 php libapache2-mod-php php-mysql php-mysqli

# Abilitazione e avvio di Apache
systemctl enable apache2
systemctl start apache2

# Installazione di Adminer per gestione database
mkdir -p /var/www/html/adminer
wget -q -O /var/www/html/adminer/index.php https://www.adminer.org/latest.php

# Impostazione dei permessi
chown -R www-data:www-data /var/www/html

# Riavvio di Apache per assicurarsi che tutte le modifiche siano attive
systemctl restart apache2
