# Debian / Ubuntu .deb package installer



### OS Network requirements
Ensure that your local network can allow inbound/outbound comms on these ports:
```

    3000tcp
    7900tcp
    7901tcp
    7902tcp
```


### System Requirements
The Sirius Blokchain Peer is designed to work with minimum Hardware perfomance of   1 CPU core and 2GB RAM, so your Vagrant VM must have these minimum resource specs.

As for OS Version requirements, the debian installer will run with these minimums:
```
- Debian 10 ++
- Ubuntu 19.04 ++

```
---



### Get the Debian Package!

```bash

wget https://proximax-vagrant-storage.s3-ap-southeast-1.amazonaws.com/sirius-chain-0.4.3-2.deb

```

---


### Update your OS:
```bash

sudo apt update -y && sudo apt upgrade -y

```

---




### Install the Package with APT:
```bash

sudo apt install ./sirius-chain-0.4.3-2.deb

```

Marvel at how the process installs the dependencies.

---



### Run the Sirius Peer using the MAINNET configs:
```bash

sudo sirius.bc /etc/sirius/chain/mainnet

```


# Staking?

