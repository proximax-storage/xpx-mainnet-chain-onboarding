# Harvesting account registering/unregistering

## Overview

From version 1.3.1, Sirius Chain will implement weighted voting on the blockchain.  Every harvesting account should be registered in blockchain in order to be selected as a committee member.

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

Before transitioning from v0.9.0 to v1.3.1, harvesters need to be registered.

The following utility script can be used to register your harvesting account.  The harvesting account is the account found in the `config-harvesting.properties`

```
chmod +x add-harvester-util

./add-harvester-util -url http://aldebaran.xpxsirius.io:3000 -signerPrivateKey SIGNER_PRIVATE_KEY -harvesterPublicKey HARVESTER_PUBLIC_KEY

```
Please replace the above `SIGNER_PRIVATE_KEY` and `HARVESTER_PUBLIC_KEY` where:

- `SIGNER_PRIVATE_KEY` = private key of any non-multisig account that holds XPX to do a transactions
- `HARVESTER_PUBLIC_KEY` = public key of the harvesting private key stored in `config-harvesting.properties`



<i> Note: In order to get the public key of your node harvesting key, you can create an account in the Sirius Mobile Wallet or Sirius Web Wallet using the harvesting private key.</i>

## Check Harvest Account Registration

The above utility script will send an `addHarvester` transaction to the Sirius Chain.  Once the transaction is confirmed, you should be able to see that your harvesting key is registered as a Sirius Chain harvesters by checking out the following link:

https://aldebaran.xpxsirius.io/harvesters

https://aldebaran.xpxsirius.io/account/HARVESTER_PUBLIC_KEY/harvesting

e.g.
https://aldebaran.xpxsirius.io/account/1DBCFA374315B059FDA6B08A981737CECB73912D4689069CD71850DCC3AA3031/harvesting

**NOTE:** You will be able to view whether your account is an harvester in the [Proximax Web Explorer](https://explorer.xpxsirius.io)
