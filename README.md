# guacamole-docker-mysql
This project contains scripts and docker compose files to support running Apache Guacamole as a Docker Contains using mySQL as the database for authentication.

## References
Based on the following tutorials,
- [Guacamole Documentation](https://guacamole.incubator.apache.org/doc/gug/introduction.html)
- [Linode Guacamole Tutorial](https://www.linode.com/docs/guides/installing-apache-guacamole-through-docker/)

## Requisites
This project has been tested on Ubuntu 20.04.5 LTS. 

The following software needs to be installed,
- Docker

## Usage
Clone the respository and change directory,
```
git clone https://github.com/patrickcberry/guacamole-docker-mysql.git
cd guacamole-docker-mysql
```

## mySQL
Run the setup script,
```
sh ./setup.sh
```

## Docker Compose

## TOTP 2FA

