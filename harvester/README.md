# Harvesting account registering/unregistering

## Overview

From version 1.0.0, Sirius Chain will implement weighted voting on the blockchain.  Every harvesting account should be registered in blockchain in order to be selected as a committee member.

A new plugin named committee is implemented that stores harvesting account public keys and characteristics in cache. The characteristics are:

- Activity of the harvesters (initially log(7/3)) is used for the account weight w calculation.

- The height of last block signing (initially the height at which the account was registered as a harvester).

- Effective balance of the harvester. The accounts that have insufficient effective balance won’t be elected into the committee.

- Boolean value indicating whether the harvester is eligible to harvest blocks.

- Greed of the harvester.


Two transactions for registering/unregistering harvesting accounts will be implemented:
- AddHarvesterTransaction
- RemoveHarvesterTransaction

## Register Harvesting account utility

Before transitioning from v0.9.0 to v1.0.0, harvesters need to be registered.

The following utility script can be used to register your harvesting account.  The harvesting account is the account found in the `config-harvesting.properties`

```
chmod +x add-harvester-util

./add-harvester-util -url http://aldebaran.xpxsirius.io:3000 -signerPrivateKey 0000000000000000000000000000000000000000000000000000000000000000 -harvesterPublicKey 1111111111111111111111111111111111111111111111111111111111111111
```
Please replace the above `0000000000000000000000000000000000000000000000000000000000000000` with the owner private key (account with XPX and linked to harvesting key) and `1111111111111111111111111111111111111111111111111111111111111111` with the public key of your node harvesting key.  

<i> Note: In order to get the public key of your node harvesting key, you can create an account in the Sirius Mobile Wallet or Sirius Web Wallet using the harvesting private key.</i>


## Check Harvest Account Registration

The above utility script will send an `addHarvester` transaction to the Sirius Chain.  Once the transaction is confirmed, you should be able to see that your harvesting key is registered as a Sirius Chain harvesters by checking out the following link:

https://aldebaran.xpxsirius.io/harvesters

https://aldebaran.xpxsirius.io/account/1111111111111111111111111111111111111111111111111111111111111111/harvesting
