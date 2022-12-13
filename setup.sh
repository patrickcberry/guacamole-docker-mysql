# Create the config folder

if [ -d "./guacamole-config" ] 
then
    echo "Folder already exists"
else
    echo "Creating folder guacamole-config"
    mkdir guacamole-config    
fi

# TODO: Install Docker if not present
# Check is Docker is installed
if [ -x "$(command -v docker)" ]; then
    echo "Update docker"
    # command
else
    echo "Install docker"
    # command
fi

# Download required Docker images
docker pull guacamole/guacamole 
docker pull guacamole/guacd 
docker pull mysql/mysql-server

# Run the guacamole client to generate a database configuration
# script for mysql
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./guacamole-config/initdb.sql

# TODO: Read passords from secrets file
file="./secrets.properities"

if [ -f "$file" ]
then
    echo "$file found."
    . $file

    echo "Docker Password " $docker_password
else
    echo "$file not found."
fi