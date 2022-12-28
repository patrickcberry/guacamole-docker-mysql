# Remove the config directory and all contents

if [ -d "./guacamole-config" ] 
then
    rm -r ./guacamole-config
else
    echo "Folder did not exist ..."
fi
