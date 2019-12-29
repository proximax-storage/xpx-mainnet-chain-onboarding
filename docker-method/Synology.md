# ProximaX Sirius MAINNET Onboarding

## Requirements
Synology NAS with:
- 1GB memory or more
- DSM 6.2+

Ensure that your local network allows inbound/outbound traffic on these ports:
- 7900/tcp
- 7901/tcp
- 7902/tcp

Tested on a Synology DS412+

## Pre-requisite
Install the following packages using Package Center:
- Text Editor
- Docker

Enable SSH access to use the tools:
- Go to Control Panel
- Terminal & SNMP
- Enable SSH Service

## Create folder structure
- Open File Station
- Create a folder `proximax-sirius-chain-mainnet` in `docker`

## Download and extract peer information
- Download latest version from: https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/
- Extract `public-mainnet-peer-package-vX.X.X.tar.gz` to a local folder
- Copy `data`, `logs`, `resources` and `tools` folders to `proximax-sirius-chain-mainnet` (drag-and-drop to DSM)

## Configure node
Follow [this](docker-method/README.md#generate-a-keypair) to configure using the Text Editor:
- config-user.properties
- config-node.properties
- config-harvesting.properties

You can SSH to your NAS to generate key pair and link a remote account to use delegated validating.
```
$ cd /volume1/docker/proximax-sirius-chain-mainnet/
```

## Setup Docker
- Open `Docker`
- Go to `Registry`
- Find `proximax/proximax-sirius-chain`
- Download this image
- Go to `Image`
- Click on `Launch` after downloading is finished
- Change `Container Name` to something like `proximax-sirius-chain-mainnet`
- Click on `Advanced Settings`
- Go to tab `Volume`
  - Add Folder and select `docker/proximax-sirius-chain-mainnet`, Mount path is `/chainconfig`, Read-Only is Yes
  - Add Folder and select `docker/proximax-sirius-chain-mainnet/data`, Mount path is `/data`, Read-Only is No
  - Add Folder and select `docker/proximax-sirius-chain-mainnet/logs`, Mount path is `/logs`, Read-Only is No
- Go to tab `Port Settings`
  - Add Port, Local Port is 7900, Container Port is 7900, Type is TCP
  - Add Port, Local Port is 7901, Container Port is 7901, Type is TCP
  - Add Port, Local Port is 7902, Container Port is 7902, Type is TCP
- Click on `Apply`
- Click on `Next`
- Click on `Apply`

## Show Terminal
- Go to `Container`
- Double Click `proximax-sirius-chain-mainnet`
- Go to tab `Terminal`

Node should be syncing and should look like this:
```
2019-12-17 12:30:46.062758 0x00007f50c158e700: <info> (chain::ChainSynchronizer.cpp@207) peer returned 400 blocks (heights 6002 - 6401)
```
