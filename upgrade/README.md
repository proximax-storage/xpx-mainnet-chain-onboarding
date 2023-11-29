# Weighted Voting Implmentation (Fast Finality)

## Overview

Currently every harvester node generates a block every 15 seconds in average and builds its own local chain which it synchronizes with other nodes from time to time. This process makes rollbacks inevitable. In order to achieve fast finality property current chain building is reworked. Harvesting and chain synchronization tasks are disabled. Weighted voting is implemented in a separate extension.

## Harvesting Account Registration
Every harvesting account should be registered in blockchain in order to be selected as a committee member.

A new plugin named committee is implemented that stores harvesting account public keys and characteristics in cache. The characteristics are:

1. Activity of the harvesters (initially log(7/3)) is used for the account weight w calculation.

2. The height of last block signing (initially the height at which the account was registered as a harvester).

3. Effective balance of the harvester. The accounts that have insufficient effective balance won’t be elected into the committee.

4. Boolean value indicating whether the harvester is eligible to harvest blocks.

5. Greed of the harvester.

Two transactions for registering/unregistering harvesting accounts will be implemented.

These transactions can be created in:
1. `add-harvester-util` (located in harvester folder)
2. [web-wallet](https://web-wallet.xpxsirius.io) (coming soon)


## Upgrading from v0.9.0 to v1.3.0

The Sirius Chain Mainnet will be upgraded to version `1.3.0` and the network config will be updated at the same time to enable `Weighted Voting`.

All node owners need to wait for the upgrade to take effect. It is extremely **IMPORTANT** to wait until EACH node stops increasing chain height before stopping them. The docker image for Sirius Chain v1.3.0 will be released to Dockerhub once the network has reached the upgrade height. There is an `upgrade` script located in the Git repository to assist node owner with the upgrade process.

The `upgrade` script will:
- prompt the node owner to update the bootkey if the bootkey conflicts with the harvesting key
- prompt node owner to register their harvest key in the blockchain.
- wait for upgrade chain height
- stop the sirius chain node
- update the node config
- pull the latest docker image version
- start the sirius chain node.
