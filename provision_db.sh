n#!/bin/bash

# Aggiornamento del sistema
sudo apt-get update -y

# Installazione di MySQL
sudo apt-get install -y mysql-server

# Avvio e abilitazione di MySQL
sudo systemctl enable mysql
sudo systemctl start mysql

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

#Comando che consente di effetture connessioni remote
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
