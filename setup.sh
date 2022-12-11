if ![ -d "./guacamole-config" ] 
then
    echo "Creating folder guacamole-config"
    md guacamole-config
else
    echo "Folder already exists"
fi

### docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql