if [ -d "./guacamole-config" ] 
then
    echo "Folder already exists"
else
    echo "Creating folder guacamole-config"
    md guacamole-config    
fi

### docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql