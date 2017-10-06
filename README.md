# Vagrant PHP7 
Standart Vagrantfile for KDS development

## Prerequisit 
- NFS Server
````
apt-get install nfs-kernel-server (ubuntu)
````

## What's inside?

- Ubuntu Xenial64
- Vim, Git, Curl, etc.
- Apache
- PHP7 with some extensions
- MySQL 5.6
- Redis
- Composer
- phpMyAdmin

## How to use

- Clone this repository into your project
- Run ``vagrant up``
- Navigate to ``http://localhost:8080/`` 
- Navigate to ``http://localhost:8080/pma/`` (both username and password are 'root')
