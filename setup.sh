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
docker run --name ras-mysql -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -d mysql/mysql-server

# takes some time for mySQL to initalise. Need to test the log until we can see the
# one time password has been written

while ! true; do
    result = $(docker logs ras-mysql | grep -nE "PASSWORD:")
    echo "DEBUG: Result is $result"
    if (( $result > 0 )) then
        echo "Debug: complete"
        break
    fi
    sleep 10
done

# Extract the onwtime password and save to file

docker logs ras-mysql | grep -e "PASSWORD:" | sed 's/.*PASSWORD: \(.*\)/\1 /' > guacamole-config/tmp-mysql-otpw.txt
myfilesize=$(wc -c "guacamole-config/tmp-mysql-otpw.txt" | awk '{print $1}')

echo "DEBUG: file size: $myfilesize"
echo "Sleep 10"

sleep 10 

docker logs ras-mysql | grep -e "PASSWORD:" | sed 's/.*PASSWORD: \(.*\)/\1 /' > guacamole-config/tmp-mysql-otpw.txt
myfilesize=$(wc -c "guacamole-config/tmp-mysql-otpw.txt" | awk '{print $1}')

echo "DEBUG: file size: $myfilesize"

