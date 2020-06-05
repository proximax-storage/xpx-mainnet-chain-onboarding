# ProximaX Sirius MAINNET Onboarding for API Validator Node

## OS Requirements
Ensure that your local network allows inbound/outbound traffic on these ports:
- 3000/tcp
- 7900/tcp
- 7901/tcp
- 7902/tcp

A note on System Requirements:
Theoretically, this dockerized Sirius API package can run on any OS running Docker version 19.03.3 and docker-compose version 1.24.0.

But if you really need a minimum benchmark, we have seen the Sirius Blockchain Peer to work with a minimum Hardware of 2 CPU core and 4GB RAM.

This README was prepared by testing the package on:
- Debian 10 ++
- Ubuntu 19.04 ++
- CentOS 7 ++

## Pre-requisite
This onboarding method requires `docker` and `docker-compose`.  

Run the following command to install `docker`:
```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

As per docker post-installation note, we recommend using Docker as a non-root user.  Therefore, you should now consider adding your user to the "docker" group with something like:
```
$ sudo usermod -aG docker $your_user
```
Remember that you will have to log out and back in for this to take effect!"

Installation instructions for docker-compose can be found [here](https://docs.docker.com/compose/install/). 

Enable and start Docker:
```
$ sudo systemctl enable docker.service
$ sudo systemctl start docker.service
$ sudo systemctl status docker.service
```
## Download and Extract the package

### For new peer setup

**If you are upgrading from a previous version, please skip this section and go to next section below**

```sh
wget https://files.proximax.io/public-mainnet-api-package-latest.tar.gz
# verify the SHA256 Hash Checksum is correct
wget https://files.proximax.io/public-mainnet-api-package-latest.tar.gz.sha256
shasum -c public-mainnet-api-package-latest.tar.gz.sha256
# If ok, you have downloaded an authentic file, otherwise the file is corrupted.
tar -xvf public-mainnet-api-package-latest.tar.gz
# rename folder
mv public-mainnet-api-package-v0.6.2 public-mainnet-api-package
cd public-mainnet-api-package
```

## Upgrading

The following instruction is assuming that existing node installation is located in `~/public-mainnet-api-package`.  If it is different, please change the path accordingly.

Make sure you have `rsync` installed. if not, follow either of the commands below.

```
yum install rsync // using yum 
```
or
```
apt-get install rsync // using advance package tool (apt)
```

After installing `rsync`, run the following commands to pull the latest package.

```sh
# stop docker
cd ~/public-mainnet-api-package
docker-compose down

# download new files in tmp folder
cd /tmp
wget https://files.proximax.io/public-mainnet-api-package-latest.tar.gz
tar -xvf public-mainnet-api-package-latest.tar.gz
# verify the SHA256 Hash Checksum is correct
wget https://files.proximax.io/public-mainnet-api-package-latest.tar.gz.sha256
shasum -c public-mainnet-api-package-latest.tar.gz.sha256
# If ok, you have downloaded an authentic file, otherwise the file is corrupted.
rsync -av --progress \
    --exclude 'data' \
    --exclude 'mongodata' \
    --exclude 'resources/config-user.properties' \
    --exclude 'resources/config-node.properties' \
    --exclude 'resources/config-harvesting.properties' 
    public-mainnet-api-package-v0.6.2/ ~/public-mainnet-api-package

# resume docker
cd ~/public-mainnet-api-package
docker-compose up -d
```

## Assign keys to Node and Rest

To set up node bootkeys and client rest keys for the API node, run the following script:

```
$ tools/auto_install_keys.sh
```

The script will generate random keypairs and will insert the node bootkey and client rest key into the following files: `resources/config-user.properties` and `restuserconfig/rest.json`

## Assign a friendly name in  [config-node.properties](resources/config-node.properties) (OPTIONAL)

Add the domain name or public IP address to the `host` parameter, leave empty to auto-detect. Add a `friendlyName` to assign a name to your node (like: `mainnet-looneytoons-01`).

```
[localnode]

host =
friendlyName =
version = 0
roles = Api
```

## Delegated Validating
You may activate your account for delegated validating by running the following tool:
```
$ tools/delegated_validating_mainnet
```

After running the above tool, add the delegated remote account private key in the [config-harvesting.properties](resources/config-harvesting.properties):
```
[harvesting]
# private keys are 64 characters
harvestKey = REMOTE_ACCOUNT_PRIVATE_KEY
beneficiary = 0000000000000000000000000000000000000000000000000000000000000000
isAutoHarvestingEnabled = true
maxUnlockedAccounts = 5
```

Verify that your account has successfully activated delegated validation by checking ProximaX online [explorer](https://explorer.xpxsirius.io) using the generated transaction hash or using your account address.

Please note that if your account does not have any XPX or previously linked to another remote account, the transaction will be unsuccessful.

**For more info, please read our online documentations [here](https://bcdocs.xpxsirius.io/docs/protocol/validating/)**

## Start the API Node

```
$ docker-compose up -d
```

## Check if container is running

```
$ docker-compose ps
```
There should be 3 containers running:
- catapult-api-node
- rest-gateway
- mongo

## Testing REST API

Run the following to test your API node:

```sh
# check network info:
curl http://localhost:3000/network
# check node chain height:
curl http://localhost:3000/chain/height
# check api node info:
curl http://localhost:3000/node/info
```

If the above is successful, you may make REST API calls to your node.  Run the following to get the public IP address of our node

```sh
curl ifconfig.me
```

Use the ip address that you get from `curl ifconfig.me` and enter into the web-browser as follow http://<node public ip address>:3000/chain/height.

Example:
In the linux shell terminal:  `$curl ifconfig.me` outputs `202.187.132.85`

I will enter the following in my Chrome web browser:
http://202.187.132.85:3000/chain/height
and I should see something like this: `{"height":[1440873,0]}`

If the above fails, please check your node's firewall setting and that port 3000 is accessible from the Internet.

You can add your node to the web explorer `http://explorer.xpxsirius.io`.  Select `node`, `Add node`, key in `http://<ip_address>:3000`, and click `Add`.  Your node should appear in the Node section of the explorer.

Refer to [here](https://bcdocs.xpxsirius.io/endpoints/) to get the full list of available endpoints of **ProximaX Sirius Chain**.

## Stop the API Node
```
$ docker-compose down
```

## Restart the API Node
```
$ docker-compose restart
```

## Check logs
There are 2 ways to view the logs:

1. docker logs

```sh
# check logs of API node
$ docker-compose logs --tail=100 -f catapult-api-node
# Press Ctrl-C to stop tailing the logs

# check logs of Mongo
$ docker-compose logs db

# check logs of rest-gateway
$ docker-compose logs rest-gateway
```

2. log files in `logs` directory

## Create service and auto-start container on reboot
```
$ sudo nano /etc/systemd/system/sirius-chain-mainnet.service
```

Put this text in this file and replace `PATH_OF_YML_FILE`:
```
# /etc/systemd/system/sirius-chain-mainnet.service

[Unit]
Description=Sirius Chain Mainnet (Docker)
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=PATH_OF_YML_FILE (like: /opt/public-mainnet-onboarding)
ExecStart=/usr/local/bin/docker-compose up -d
ExecStop=/usr/local/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

```
$ sudo systemctl daemon-reload
$ sudo systemctl enable sirius-chain-mainnet
```

If the Docker container isn't running yet, you can start the container using this command:
```
$ sudo systemctl start sirius-chain-mainnet
```

## Reset Chain

When the service won't start or you have a corrupted database, you can reset the chain with the following:

```sh
$ docker-compose down
$ ./reset.sh
$ docker-compose up
```

## Helpdesk
We have a [telegram helpdesk](https://t.me/proximaxhelpdesk) to assist general queries.

For validation-specific queries, you may discuss it at [ProximaX Blockchain Validators Group](https://t.me/xpxtestnetvalidator)
