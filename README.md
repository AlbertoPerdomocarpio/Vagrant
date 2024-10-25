
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
└── provision.sh        # Script di provisioning per MySQL
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


## Contatti

Per domande o suggerimenti, puoi contattarmi all'indirizzo email: alberto.perdomocarpio@samtrevano.ch
