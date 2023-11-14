#!/bin/bash 

PEER="genesiseridani.brimstone.xpxsirius.io"
DOCKER_IMAGE="proximax/proximax-sirius-chain:v0.9.0-bullseye"
API_NODE="arcturus.xpxsirius.io"
sync=false
min_height=5

while [[ $sync != true ]]; do 
    node_height=$(docker run -it -v $PWD:/chainconfig --entrypoint /sirius/bin/catapult.tools.health $DOCKER_IMAGE /chainconfig | grep "$PEER.* at height [^\d].*" | grep -Pzo "$PEER.* at height \K.\d+")
    network_height=$(curl $API_NODE:3000/chain/height | jq -r ".height.[0]")
    harvesting_enabled=$(cat resources/config-harvesting.properties | grep -Po "isAutoHarvestingEnabled = \K\w+")

    if [[ $node_height+$min_height -lt $network_height ]]
    then
        sync=false
    else
        sync=true
    fi

    if [[ $sync != $harvesting_enabled ]]
    then
        harvesting_enabled=$sync
        sed -i "s/^isAutoHarvestingEnabled = .*/isAutoHarvestingEnabled = true/g" resources/config-harvesting.properties
        docker-compose restart
        echo "Harvesting is now $harvesting_enabled"
    fi

    
    if [[ $sync != true ]]
    then
        rest_time=$(( $(($network_height-$node_height)) *15))
        # echo "Network Height: $network_height, Node Height: $node_height, Sleep Time until harvest: $rest_time"
        sleep $rest_time
    fi
done
