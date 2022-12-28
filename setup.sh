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
if false == true; then 
    docker pull guacamole/guacamole 
    docker pull guacamole/guacd 
    docker pull mysql/mysql-server
fi

# Run the guacamole client to generate a database configuration
# script for mysql
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./guacamole-config/initdb.sql

# Read passords from secrets file
file="./secrets.properities"

if [ -f "$file" ]
then
    echo "$file found."
    . $file

    echo "Docker Password    " $docker_password
    echo "mySQL Password     " $mysql_password
    echo "Guacamole Password " $guacadmin_password
else
    echo "$file not found."
fi

# Generate a mySQL one-time password and save to a temporary file

echo "Initalising the mySQL server ..."
echo "This can take some time ... inital wait 20 seconds before testing for OTPW ..."

docker run --name ras-mysql -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -d mysql/mysql-server

# Extract the onwtime password and save to file
# takes some time for mySQL to initalise. Need to test the log until we can see the
# one time password has been written

sleep 20

while true; do
    docker logs ras-mysql | grep -e "PASSWORD:" | sed 's/.*PASSWORD: \(.*\)/\1 /' > guacamole-config/tmp-mysql-otpw.txt
    otpw_file_size=$(wc -c "guacamole-config/tmp-mysql-otpw.txt" | awk '{print $1}')    

    if test $otpw_file_size -eq "0"
    then
        echo "otpw_file_size: $otpw_file_size"
        echo "Processing (waiting 10 seconds to check for otpw)..."
        sleep 10
    else
        echo "Password found"
        break
    fi

done

otpw="$(cat guacamole-config/tmp-mysql-otpw.txt)"
echo "otpw_file_size: $otpw_file_size"
echo "The OTWP:       $otpw"

# ##############################################
# Change mySQL root user password

docker exec -i ras-mysql mysql --connect-expired-password -u root --password="$otpw" -e "EXIT;"
#docker exec -i ras-mysql mysql --connect-expired-password -u root --password="$otpw" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysql_password'; FLUSH PRIVILEGES; EXIT;"

# ##############################################
# Create Guacamole database

# ##############################################
# Create Guacamole user

# ##############################################
# Run the database setup script

# ##############################################
# Verify db setup

# ##############################################
# Start GUACD container

# ##############################################
# Start Guacamole container
