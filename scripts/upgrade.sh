#!/usr/bin/bash

## Declare variables
# VARS:
DEFAULT_PATH="/mnt/siriuschain/"
SERVICENAME="mainnet-peer"
SIRIUS_CHAIN_VERSION="release-v1.4.2"
DOCKERFOLDER='docker-method'

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
node_role=$(sed -n -e '/roles/ s/.*= *//p' config-node.properties)

if [ $node_role == 'Api' ]; then
  DOCKERFOLDER='docker-api'
  SERVICENAME="catapult-api-node"
fi

echo Existing Configuration:
echo "Friendly Name is $friendly_name"
echo "Host is $node_host"
echo "Node is: " $node_role
printf "BootKey is "; mask $boot_key
printf "HarvestKey is "; mask $harvest_key

if [ $boot_key == $harvest_key ]; then
  echo "Node bootkey conflicts with harvest key.  Please update the Node Bootkey"
  # TODO script to update node bootkey
  exit 1
fi

# TODO check if node is harvesting.  
# If yes and to upgrade above v0.9.0, check that harvest key is registered as harvester

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

echo "Creating backup for resources directory and docker-compose.yml"
cd $base_dir
if [ -d ./backup ]; then
    echo "Directory backup exists in $base_dir"
    exit 1
fi

echo "Create backup folder in $base_dir"
mkdir backup
cp docker-compose.yml backup/
cp -r resources/ backup/

echo "Download $SIRIUS_CHAIN_VERSION/$DOCKERFOLDER config files"
cd $base_dir
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/docker-compose.yml
cd resources
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-database.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-dbrb.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-extensions-broker.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-extensions-recovery.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-extensions-server.properties
# curl -O --silent DONT'T UPDATE https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-harvesting.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-immutable.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-inflation.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-logging-broker.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-logging-recovery.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-logging-server.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-messaging.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-network.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-networkheight.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-node.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-pt.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-task.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-timesync.properties
# curl -O --silent DONT'T UPDATE https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/config-user.properties
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/peers-api.json
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/peers-p2p.json
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/$SIRIUS_CHAIN_VERSION/$DOCKERFOLDER/resources/supported-entities.json

echo "Updating config files"
sed -i "s/^\(host\s*=\s*\).*\$/\1$node_host/" config-node.properties
sed -i "s/^\(friendlyName\s*=\s*\).*\$/friendlyName = $friendly_name/" config-node.properties
cd $base_dir
# instructions
echo "
###########################################################################
## Configuration complete.  To start your sirius chain, run the following:

cd $base_dir
$compose_cmd up -d

###########################################################################
"
