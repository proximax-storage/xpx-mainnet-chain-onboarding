# ProximaX Sirius MAINNET Onboarding

## OS Requirements
Ensure that your local network allows inbound/outbound traffic on these ports:
- 3000/tcp
- 7900/tcp
- 7901/tcp
- 7902/tcp
- 7903/tcp

A note on System Requirements:
Theoretically, this dockerized Sirius Peer package can run on any OS running Docker version 20.10 and docker-compose version 1.24.0.

But if you really need a minimum benchmark, we have seen the Sirius Blockchain Peer to work with a minimum Hardware of 1 CPU core and 2GB RAM.

This README was prepared by testing the package on:
- Debian 10 ++
- Ubuntu 22.04 ++
- CentOS 7 ++

## Pre-requisite
This onboarding method requires `docker` and `docker-compose`.  

Run the following command to install `docker`:
```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

As per docker post-installation note, we recommend using Docker as a non-root user.  Therefore, you should now consider adding your user to the "docker" group with something like:
```sh
sudo usermod -aG docker $your_user
```
Remember that you will have to log out and back in for this to take effect!"

Installation instructions for docker-compose can be found [here](https://docs.docker.com/compose/install/). 

```
#download and install compose standalone
sudo curl -SL https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
```

Enable and start Docker:
```sh
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo systemctl status docker.service
```

## Download and Extract the package

### For new peer setup

**If you are upgrading from a previous version, please skip this section and go to next section below**

**The following instructions will setup your node for version 0.9.0.  You will need to upgrade your node from v0.9.0 to v1.3.1 and above.  Please don't skip the upgrade section**

```sh
wget https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/download/release-v0.9.0/public-mainnet-peer-package-release-v0.9.0.tar.gz
# verify the SHA256 Hash Checksum is correct
wget https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/download/release-v0.9.0/public-mainnet-peer-package-release-v0.9.0.tar.gz.sha256
shasum -c public-mainnet-peer-package-release-v0.9.0.tar.gz.sha256
# If ok, you have downloaded an authentic file, otherwise the file is corrupted.
tar -xvf public-mainnet-peer-package-release-v0.9.0.tar.gz
cd public-mainnet-peer-package
```

## Assign a friendly name in  [config-node.properties](resources/config-node.properties) (OPTIONAL)

Add the domain name or public IP address to the `host` parameter, leave empty to auto-detect. Add a `friendlyName` to assign a name to your node (like: `mainnet-looneytoons-01`).

```
[localnode]

host =
friendlyName =
version = 0
roles = Peer
```

## Delegated Validating
You may activate your account for delegated validating by running the following tool:
```sh
chmod +x tools/delegate_harvesting_mainnet
tools/delegate_harvesting_mainnet
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

## Generate a keypair for bootkey
```sh
chmod +x tools/gen_keypair_addr
tools/gen_keypair_addr
```

## Insert private key in [config-user.properties](resources/config-user.properties)

Replace `BOOTKEY_PRIVATE_KEY` with the generated private key from the previous step.

```
[account]

bootKey = BOOTKEY_PRIVATE_KEY 

[storage]

dataDirectory = /data
pluginsDirectory = 
```

## Start the Peer Node
```sh
chmod +x entrypoint.sh
docker-compose up -d
```

## Check if container is running
```sh
docker container ls
```

## Stop the Peer Node
```sh
docker-compose down
```

## Restart the Peer Node
```sh
docker-compose restart
```

## Check logs
There are 2 ways to view the logs:
1. docker logs
```sh
docker-compose logs --tail=100 -f
# Press Ctrl-C to stop tailing the logs
```

2. log files in `logs` directory

## Create service and auto-start container on reboot
```
sudo nano /etc/systemd/system/sirius-chain-mainnet.service
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

```sh
sudo systemctl daemon-reload
sudo systemctl enable sirius-chain-mainnet
```

If the Docker container isn't running yet, you can start the container using this command:
```sh
sudo systemctl start sirius-chain-mainnet
```

## Reset Chain

When the service won't start or you have a corrupted database, you can reset the chain with the following:

```sh
docker-compose down
chmod +x reset.sh
sudo ./reset.sh
docker-compose up
```

## Upgrading

For upgrading, please refer to the following [README](../upgrade/README.md) in upgrade folder.

## Restore from Snapshot

```
snapshot-filename="mainnet-backup-2023.12.31.tar.xz"
echo "downloading snapshot and check sum"
wget https://sirius-chain-mainnet-backup.s3.ap-southeast-1.amazonaws.com/$snapshot-filename.sha256
wget https://sirius-chain-mainnet-backup.s3.ap-southeast-1.amazonaws.com/$snapshot-filename
shasum -c $snapshot-filename.sha256

echo "deleting data directory"
for dir in ./data/*; do
  sudo rm -rf $dir
done

if [ -d "./mongodata" ]; then
    echo "deleting mongodata directory"
    for dir in mongodata/*; do
        sudo rm -rf $dir
    done
fi

tar -xvf $snapshotfilename data
```

## Helpdesk
We have a [telegram helpdesk](https://t.me/proximaxhelpdesk) to assist general queries.

For validation-specific queries, you may discuss it at [ProximaX Blockchain Validators Group](https://t.me/xpxtestnetvalidator)
