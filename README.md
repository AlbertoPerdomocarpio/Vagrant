
# Provisioning Vagrant per MySQL

Questo progetto fornisce uno script di provisioning per configurare una macchina virtuale Vagrant con MySQL. Durante il provisioning, verrà installato MySQL, creato un database con due tabelle e configurato un utente con i permessi necessari.

## Prerequisiti

Assicurati di avere installato sul tuo sistema:

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Struttura del Progetto

```
/my-vagrant-project
│
├── Vagrantfile         # Configurazione di Vagrant
├── provision.sh        # Script di provisioning per MySQL
└── provision_web.sh    # Script di provisioning per Apache e PHP
```

## Configurazione

1. **Clona il repository**:

   ```bash
   git clone https://github.com/tuo-username/tuo-repo.git
   cd tuo-repo
   ```

2. **Modifica il file `Vagrantfile`** (opzionale): Puoi personalizzare la box e la rete. Per impostazione predefinita, è configurato per utilizzare una box Ubuntu.

3. **Esegui Vagrant**:

   ```bash
   vagrant up
   ```

   Questo comando avvierà la macchina virtuale e eseguirà lo script di provisioning. Durante questo processo, verrà installato MySQL e configurato il database.

## Dettagli dello Script di Provisioning

Lo script `provision.sh` esegue le seguenti operazioni:

1. **Installazione di MySQL**: Aggiorna il sistema e installa il server MySQL.
2. **Creazione del Database**: Crea un database denominato `DB`.
3. **Creazione delle Tabelle**: Crea due tabelle nel database:
   - `customers`: per memorizzare informazioni sui clienti.
   - `orders`: per memorizzare ordini collegati ai clienti.
4. **Creazione dell'Utente**: Crea un utente `admin` con accesso da qualsiasi host e concede tutti i privilegi sul database.

### Contenuto di `provision.sh`

```bash
#!/bin/bash

# Configurazione delle variabili
DB_NAME="DB"
DB_USER="admin"
DB_PASS="password"

# Creazione del database, delle tabelle e dell'utente con permessi
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
USE ${DB_NAME};

CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product VARCHAR(50),
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Conferma di completamento
echo "Database ${DB_NAME} con utente ${DB_USER} e tabelle creato correttamente."
```

## Dettagli dello Script di Provisioning per il Server Web

Lo script `provision_web.sh` esegue le seguenti operazioni:

1. **Aggiornamento del Sistema**: Esegue un aggiornamento del sistema operativo.
2. **Installazione di Apache e PHP**: Installa il server web Apache e le estensioni PHP necessarie per collegarsi a MySQL.
3. **Abilitazione e Avvio di Apache**: Abilita Apache all'avvio e lo avvia immediatamente.
4. **Installazione di Adminer**: Scarica e installa Adminer, un'interfaccia web per la gestione dei database MySQL.
5. **Impostazione dei Permessi**: Imposta i permessi corretti per la cartella di Adminer.
6. **Riavvio di Apache**: Riavvia Apache per applicare tutte le modifiche.

### Contenuto di `provision_web.sh`

```bash
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
```

## Vagrantfile

Il file `Vagrantfile` definisce la configurazione per le macchine virtuali. Contiene le seguenti sezioni:

- **Definizione delle variabili**: Specifica l'immagine della box e gli indirizzi di rete.
- **Configurazione della VM Web**: Configura la macchina virtuale per il server web, impostando la rete, la cartella condivisa e il provisioning con lo script `provision_web.sh`.
- **Configurazione della VM Database**: Configura la macchina virtuale per il database, impostando la rete e il provisioning con lo script `provision_db.sh`.

### Contenuto di `Vagrantfile`

```ruby
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
```

## Connessione al Database

Dopo il provisioning, puoi connetterti al database MySQL utilizzando l'utente creato:

```bash
mysql -u admin -p -h 192.168.33.10 DB
```

Dove `192.168.33.10` è l'indirizzo IP della tua macchina virtuale.

## Note

- Assicurati di controllare eventuali errori durante il provisioning controllando il file di log generato (se implementato).
- Per fermare la macchina virtuale, usa:

   ```bash
   vagrant halt
   ```

- Per distruggere la macchina virtuale, usa:

   ```bash
   vagrant destroy
   ```

## Licenza

Questo progetto è sotto licenza [MIT](LICENSE).

## Contatti

Per domande o suggerimenti, puoi contattarmi all'indirizzo email: tuo-email@example.com
