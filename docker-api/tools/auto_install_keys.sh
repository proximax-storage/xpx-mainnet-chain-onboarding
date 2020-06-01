#!/usr/bin/env bash

bootkey=($(./tools/gen_keypair_addr | sed -e 's/^[^:]*://'))
sed -i "s/BOOTKEY_PRIVATE_KEY/${bootkey[0]}/g" resources/config-user.properties
sed -i "s/BOOTKEY_PUBLIC_KEY/${bootkey[1]}/g" restuserconfig/rest.json


restkey=($(./tools/gen_keypair_addr | sed -e 's/^[^:]*://'))
sed -i "s/REST_PRIVATE_KEY/${restkey[0]}/g" restuserconfig/rest.json

echo "updated resources/config-user.properties and restuserconfig/rest.json"