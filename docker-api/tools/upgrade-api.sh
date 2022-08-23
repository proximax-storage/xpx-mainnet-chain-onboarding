#!/usr/bin/bash

## Declare variables
# VARS:
DEFAULT_PATH="/mnt/siriuschain/"
SIRIUS_CHAIN_VERSION="release-v0.9.0"
API_PACKAGE="public-mainnet-api-package-$SIRIUS_CHAIN_VERSION.tar.gz"
DOWNLOAD_URL="https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/download/$SIRIUS_CHAIN_VERSION/$API_PACKAGE"

## Functions

mask() {
    local n=6                    # number of chars to leave
    local a="${1:0:n}"           # take the first n chars
    local c="${1:${#1}-n}"       # take the last n chars
    local b="${1:n:-n}"          # take the chars between a and c
    printf "%s%s%s\n" "$a" "${b//?/*}" "$c"
}


## Prompt
# Base installation directory
printf "Enter base installation directory [default: $DEFAULT_PATH]:" 
read base_dir

if [ -z "$base_dir" ]; then
  echo "empty.  setting base directory to default $DEFAULT_PATH"
  base_dir=$DEFAULT_PATH
fi


if [ ! "$(ls -A $base_dir)" ]; then 
    echo "$base_dir does not exists."
    exit 1
fi

cd $base_dir

# verify whether there is an existing installation
# TODO

# retrieve existing data

cd resources
node_host=$(sed -n '/^host\s*=\s*/{s/^host\s*=\s*//;p}' config-node.properties)
friendly_name=$(sed -n '/^friendlyName\s*=\s*/{s/^friendlyName\s*=\s*//;p}' config-node.properties)
boot_key=$(sed -n '/^bootKey\s*=\s*/{s/^bootKey\s*=\s*//;p}' config-user.properties)
harvest_key=$(sed -n '/^harvestKey\s*=\s*/{s/^harvestKey\s*=\s*//;p}' config-harvesting.properties)
boot_pubkey=$(echo $(grep publicKey restuserconfig/rest.json) | cut -d : -f2 | awk -F\" '{print $2}')
rest_key=$(echo $(grep clientPrivateKey restuserconfig/rest.json) | cut -d : -f2 | awk -F\" '{print $2}')

echo Existing Configuration:
echo "Friendly Name is $friendly_name"
echo "Host is $node_host"
printf "BootKey is "; mask $boot_key
printf "HarvestKey is "; mask $harvest_key
printf "REST clientPrivateKey is "; mask $rest_key
echo "API node publicKey is $boot_pubkey"

while true; do
    read -p "Is the configuration correct? (y/n) " yn
    case $yn in 
        [yY] ) echo ok, we will proceed;
                break;;
        [nN] ) echo exiting...;
                exit;; #TODO re-run setup?
        * ) echo invalid response;
    esac
done


# stop docker just in case
output="$(docker compose version)"

if [[ $? -eq 0 ]] ; then
    echo "docker compose is installed"
    compose_cmd="docker compose"
else 
    if [ -x "$(command -v docker-compose)" ]; then
        echo "docker-compose is installed"
        compose_cmd="docker-compose"
    else
        echo "docker-compose is not installed"
        exit 1
    fi
fi

echo "stopping sirius chain docker just in case"
cd $base_dir
$compose_cmd down

## Download package from repository
wget $DOWNLOAD_URL -P /tmp
tar -xvf /tmp/$API_PACKAGE public-mainnet-api-package/resources public-mainnet-api-package/docker-compose.yml public-mainnet-api-package/restuserconfig public-mainnet-api-package/scripts
cp -r public-mainnet-api-package/* .
rm -rf public-mainnet-api-package
rm /tmp/$API_PACKAGE 

# Resources
cd resources
sed -i "s/^\(host\s*=\s*\).*\$/\1$node_host/" config-node.properties
sed -i "s/^\(friendlyName\s*=\s*\).*\$/friendlyName = $friendly_name/" config-node.properties
sed -i "s/^\(harvestKey\s*=\s*\).*\$/\1$harvest_key/" config-harvesting.properties
sed -i "s/^\(bootKey\s*=\s*\).*\$/\1$boot_key/" config-user.properties
sed -i "s/BOOTKEY_PUBLIC_KEY/$boot_pubkey/g" restuserconfig/rest.json
sed -i "s/REST_PRIVATE_KEY/$rest_key/g" restuserconfig/rest.json

cd ..

# instructions
echo "
###########################################################################
## Configuration complete.  To start your sirius chain, run the following:

cd $base_dir
$compose_cmd up -d

###########################################################################
"
