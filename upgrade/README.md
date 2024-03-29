# Weighted Voting Implementation (Fast Finality)

## Overview

Currently every harvester node generates a block every 15 seconds on average and builds its own local chain which it synchronizes with other nodes from time to time. This process makes rollbacks inevitable. In order to achieve fast finality properly current chain building is reworked. Every new block is generated by a single selected node, after which the block is confirmed by a committee. After the block is confirmed all nodes add it to their local chains.

## Harvesting Account Registration
Every harvesting account should be registered in blockchain in order to be selected as a committee member.

A new plugin named committee is implemented that stores harvesting account public keys and characteristics in cache. The characteristics are:

1. Activity of the harvesters (initially log(7/3)) is used for the account weight w calculation.

2. The height of last block signing (initially the height at which the account was registered as a harvester).

3. Effective balance of the harvester. The accounts that have insufficient effective balance won’t be elected into the committee.

4. Boolean value indicating whether the harvester is eligible to harvest blocks.

5. Greed of the harvester.

Two transactions for registering/unregistering harvesting accounts are implemented.

These transactions can be created in:
1. `add-harvester-util` (located in harvester folder)
2. [web-wallet](https://web-wallet.xpxsirius.io) (coming soon)


## Upgrading from v0.9.0 to v1.4.2

The Sirius Chain Mainnet will be upgraded to version `v1.4.2` and the network config will be updated at the same time to enable `Weighted Voting`.

`Weighted Voting` keeps the same state of blockchain on every node. On the other hand `NXT based consensus` protocol which is now running in mainnet allows small forks on the tail of the chain which appear all the time and are resolved automatically when the nodes synchronize their local chains with each other. In order to switch to `Weighted Voting` all nodes should run `v0.9.0` until the upgrade height is reached, the nodes will then stop produce new blocks. Then, after all small tail forks are resolved and all the nodes have the same state, the nodes should run `v1.4.2`.

The docker image for Sirius Chain `v1.4.2` will be released to Dockerhub once the network has reached the upgrade height.

There is an `upgrade_util` CLI tool located in the Git repository to assist node owner with the upgrade process.
The `upgrade_util` CLI tool will:
- ask for a directory where the node is installed. Default: /mnt/siriuschain
- ask for a REST server URL. Default: http://aldebaran.xpxsirius.io:3000
- prompt the node owner to update the boot key if the boot key is a multisig or conflicts with the harvesting key
- prompt node owner to register the harvest key in the blockchain if it is not yet registered. In that case the tool will ask for the private key of account on behalf of which the harvest key will be registered, that account will pay transaction fee.
- wait for upgrade chain height and resolving of the tail forks
- stop the sirius chain node
- update the node config

Run the following commands to download and execute the `upgrade_util` CLI:
```bash 
wget https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/release-v1.4.2/upgrade/upgrade_util
chmod +x ./upgrade_util
./upgrade_util
```

After the tool completes its work successfully, run the following steps:
```
cd resources
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/release-v1.4.2/docker-method/resources/peers-api.json
curl -O --silent https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/release-v1.4.2/docker-method/resources/peers-p2p.json
sed -i "s/^\(minFeeMultiplier\s*=\s*\).*\$/minFeeMultiplier = 140'000/" config-node.properties
```

The above updates the peer files and fee multiplier.  In future, the above steps will be included in the `upgrade_util` tool/

Once the post-upgrade configuration steps are done, run the node with command:
```bash
docker-compose up -d
```

## Upgrading to v1.5.3

Run the following commands to download and execute the `upgrade.sh` script:
```bash 
wget https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/release-v1.5.3/scripts/upgrade.sh
chmod +x ./upgrade.sh
./upgrade.sh
```

Once the `upgrade.sh` script has completed the configuration, run the node with command:
```bash
cd $base_dir #where $base_dir is the directory of your node installation
docker-compose up -d
```
