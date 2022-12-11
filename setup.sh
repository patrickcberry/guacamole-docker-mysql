if [ -d "./guacamole-config" ] 
then
    echo "Folder already exists"
else
    echo "Creating folder guacamole-config"
    mkdir guacamole-config    
fi

# Run the guacamole client to generate a database configuration
# script for mysql
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./guacamole-config/initdb.sql