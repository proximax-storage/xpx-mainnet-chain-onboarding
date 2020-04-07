# Sirius Chain AWS Marketplace - How It Works 

## Startup

When you first launch your instance, a new key pair is generated for delegated validating use.

The keypair is stored at `/opt/sirius-chain/mainnet-peer/node_validator.txt`.

You do not need to use this key and you may always generate your own keypair with a wallet and replace the private key located at `/opt/sirius-chain/mainnet-peer/resources/config-harvesting.properties`.

Be sure to restart the the blockchain node when you update that key.

## Node Management

The node is managed by Systemd and Docker with Docker Compose.

### Starting/Stopping/Restarting the Node

All these tasks can be performed with Systemd:

**Starting**:
```sh
sudo systemctl start sirius-chain.service
```

**Stopping**:
```sh
sudo systemctl stop sirius-chain.service
```

**Restarting**:
```sh
sudo systemctl restart sirius-chain.service
```

### Enabling Auto-restart

You can enable the service to allow the node to restart when the instance reboots or if the node encounters errors.

This should be enabled by default but this is the command to enable it:

```sh
sudo systemctl enable sirius-chain.service
```

### Viewing Logs

There are three ways you can view the logs of the node:

With the Docker CLI:
```sh
sudo docker logs mainnet-peer_mainnet-peer_1
```

With Docker Compose inside the folder: `/opt/sirius-chain/mainnet-peer`
```sh
sudo docker-compose logs mainnet-peer
```
You may want to use the following flags to make reading logs easier:

* `-f`: Follow Logs
* `--tail <number>`: Prints the last # lines of logs

Log files are also available at the following directory: `/opt/sirius-chain/mainnet-peer/logs`

### Upgrading

The easiest method to perform upgrades in the future would be to launch a new instance as it will also include the latest system security patches.

You may also update the node by using a newer Docker tag by replacing the tag inside the `docker-compose.yml` file inside `/opt/sirius-chain/mainnet-peer`.

See instructions at: <https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/tree/master/docker-method> when node updates are available including config changes.

## Instance Management

The instance is a standard Amazon Linux 2 instance with Docker and Docker Compose installed. See their respective documentation for more information on usage.
