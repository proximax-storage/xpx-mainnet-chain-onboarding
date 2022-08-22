#!/usr/bin/bash

## Declare variables
# VARS:
DOCKER_IMAGE="proximax/proximax-sirius-chain:v0.9.0-bullseye" # This info should be grapped from github
DEFAULT_PATH="/mnt/siriuschain/"
SIRIUS_CHAIN_VERSION="release-v0.9.0"
P2P_PACKAGE="public-mainnet-peer-package-$SIRIUS_CHAIN_VERSION.tar.gz"
DOWNLOAD_URL="https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/download/$SIRIUS_CHAIN_VERSION/$P2P_PACKAGE"
FRIENDLYNAME="mainnet-${HOSTNAME%%.*}"


## Prerequisite
# check whether Docker is installed
if [ -x "$(command -v docker)" ]; then
    echo "docker is installed"
else
    echo "Docker is not installed"
    exit 1
fi

output="$(docker compose version)"

if [[ $? -eq 0 ]] ; then
    echo "docker compose is installed"
    compose_cmd="docker compose"
else 
    if [ -x "$(command -v docker-compose)" ]; then
        echo "docker-compose is installed"
        compose_cmd="docker-compose"
    else
        echo "docker-composse is not installed"
        exit 1
    fi
fi


## Prompt
# Base installation directory
printf "Enter base installation directory [default: $DEFAULT_PATH]:" 
read base_dir

if [ -z "$base_dir" ]; then
  echo "empty.  setting base directory to default $DEFAULT_PATH"
  base_dir=$DEFAULT_PATH
fi
     
# Enable local echo again 
echo "Base Installation Directory is $base_dir"

if [ ! -d $base_dir ]; then 
    if [ ! -w $(dirname "${base_dir}") ]; then
        echo "Error, You don't have write permissions to $base_dir"
        exit 1
    else
        mkdir -p $base_dir;
    fi
else
    if [ "$(ls -A $base_dir)" ]; then 
        echo "$base_dir already exists and is not empty"
        exit 1
    fi
fi


## Download package from repository
wget $DOWNLOAD_URL -P /tmp
cd $base_dir
tar -xvf /tmp/$P2P_PACKAGE 
mv public-mainnet-peer-package/* .
rmdir public-mainnet-peer-package

echo "assign friendly"
pattern=" |'"
while true; do
    read -p "Assign a friendly name [DEFAULT: $FRIENDLYNAME]: " friendly_name
    if [[ $friendly_name =~ $pattern ]]; then
        echo "friendlyName cannot have white spaces"
    elif [ -z "$friendly_name" ]; then
        friendly_name="$FRIENDLYNAME"
        echo "friendlyName is $friendly_name"
        break
    else
        echo "friendlyName is $friendly_name"
        break
    fi
done

# Tools
cd tools
find -type f -not -name "*.*" -exec chmod +x \{\} \;
cd ..

# Enter private key
while true; do
    private_key=""
    prompt="Harvester Private Key: " 
    echo -n "${prompt}" >&2 
    while true; do 
        read -N 1 -s character 
        [ "${character}" == $'\n' ] && break 
        echo -n "*" >&2 
        private_key="${private_key}${character}" 
    done 
    echo >&2 
    if [[ ${#private_key} -eq 64 ]]; then
        break
    else
        echo "Private key should be 64 chars"
    fi
done

# TODO
# check whether account is linked or multisig using a golang script


# Resources
cd resources
sed -i "s/^\(friendlyName\s*=\s*\).*\$/\1$friendly_name/" config-node.properties
sed -i "s/^\(harvestKey\s*=\s*\).*\$/\1$private_key/" config-harvesting.properties
sed -i "s/^\(bootKey\s*=\s*\).*\$/\1$private_key/" config-user.properties
cd ..

#make entrypoint executable
chmod +x entrypoint.sh

# instructions
echo "
###########################################################################
## Configuration complete.  To start your sirius chain, run the following:

cd $base_dir/public-mainnet-peer-package
$compose_cmd up -d

###########################################################################
"