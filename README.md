# Onboarding the Community into ProximaX Sirius MAINNET

This readme contains the official ProximaX instructions on how to use the community distribution for a Sirius Blockchain Peer.  The deployable Peer automatically hooks-up to ProximaX MAINNET, provided you have setup the harvesterKey.

For creation of your own harvestKey, please follow wiki guide here: https://github.com/proximax-storage/community-onboarding/wiki/Creating-your-MAINNET-HarvestKey-using-the-ProximaX-WALLET

## Methods of Onboarding:

There are two main ways to use the distribution:
1. - Vagrant box
2. - Debian/Ubuntu .deb package.




# Method 1 - Vagrant box
---
This Vagrant method is the easiest onboarding execution.  The box is designed to serve a wide audience regardless of base OS used to run the box (which in turn will run the Peer).


### Local Network requirements
Ensure that your local network can allow inbound/outbound comms on these ports:
```

    3000tcp
    7900tcp
    7901tcp
    7902tcp
```


### System Requirements
The Sirius Blokchain Peer is designed to work with minimum perfomance on   1 CPU core and 2GB RAM, so your Vagrant VM must have these minimum resource specs.

### Install Vagrant on your local machine
In order to run the vagrant distribution, its a prerequisite to install vagrant first.

Access the installation steps [here](https://www.vagrantup.com/intro/getting-started/install.html)

### Download the community-oriented vagrant box for Sirius Peer Node v2
This step will show how to obtain a community peer vagrantbox based on Proximax Sirius Peer v0.4.1:

```bash
mkdir -m 777 ~/proximax-peer-v2
cd ~/proximax-peer-v2
wget https://proximax-vagrant-storage.s3-ap-southeast-1.amazonaws.com/proximax-sirius-v0.4.1-2.box
```


Once download completes, setup your vagrant environment to point to the boxfile, then initiatize it:
```bash
vagrant box add proximax-community-peer-v2 proximax-sirius-v0.4.1-2.box
vagrant init proximax-community-peer-v2
```

At this point, you will have a new Vagrantfile in your current DIR.


Go ahead and standup this box in your local machine:
```bash
vagrant up
```

SSH into your local VM using command:
```bash
vagrant ssh
```



## Running the Peer node daemon inside the VM


Once inside the VM, you will notice that Nodekeys are automatically generated for you:
```bash
$ vagrant ssh
Welcome to Ubuntu 19.04 (GNU/Linux 5.0.0-17-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information 
  
  System load:  0.05              Processes:           106
  Usage of /:   4.4% of 61.80GB   Users logged in:     0
  Memory usage: 12%               IP address for eth0: 10.0.2.15
  Swap usage:   0%

 * Keen to learn Istio? It's included in the single-package MicroK8s.

     https://snapcraft.io/microk8s

55 updates can be installed immediately.
32 of these updates are security updates.


Last login: XXXXXXXX

keys generated
vagrant@vagrant:~$ 



```



### Sirius BlockChain Config Files
Inspect the path of the config files of your Sirius Peer Node (located in path /etc/sirius/chain/resources/) :
```bash

vagrant@vagrant:~$ ls -la /etc/sirius/chain/resources/
total 88
drwxr-xr-x 2 vagrant    1001 4096 Aug 20 10:20 .
drwxr-xr-x 3 vagrant    1001 4096 Aug 20 03:54 ..
-rw-r--r-- 1 vagrant    1001  618 Aug 16 08:06 config-database.properties
-rw-r--r-- 1 vagrant    1001  213 Aug 16 08:06 config-extensions-broker.properties
-rw-r--r-- 1 vagrant    1001  216 Aug 16 08:06 config-extensions-recovery.properties
-rw-r--r-- 1 vagrant    1001  692 Aug 16 08:06 config-extensions-server.properties
-rw-r--r-- 1 vagrant vagrant  431 Aug 20 10:20 config-harvesting.properties
-rw-r--r-- 1 vagrant    1001   69 Aug 16 08:06 config-inflation.properties
-rw-r--r-- 1 vagrant    1001  362 Aug 19 02:21 config-logging-broker.properties
-rw-r--r-- 1 vagrant    1001  365 Aug 19 02:21 config-logging-recovery.properties
-rw-r--r-- 1 vagrant    1001  363 Aug 20 06:18 config-logging-server.properties
-rw-r--r-- 1 vagrant    1001   35 Aug 16 08:06 config-messaging.properties
-rw-r--r-- 1 vagrant    1001   30 Aug 16 08:06 config-networkheight.properties
-rw-r--r-- 1 vagrant    1001 2875 Aug 19 02:24 config-network.properties
-rw-r--r-- 1 vagrant    1001 1595 Aug 16 08:51 config-node.properties
-rw-r--r-- 1 vagrant    1001   76 Aug 16 08:06 config-pt.properties
-rw-r--r-- 1 vagrant    1001 1098 Aug 16 08:06 config-task.properties
-rw-r--r-- 1 vagrant    1001   37 Aug 16 08:06 config-timesync.properties
-rw-r--r-- 1 vagrant vagrant  289 Aug 20 10:20 config-user.properties
-rw-r--r-- 1 vagrant    1001  585 Aug 20 04:09 peers-api.json
-rw-r--r-- 1 vagrant    1001 1576 Aug 20 04:16 peers-p2p.json
-rw-r--r-- 1 vagrant    1001 2106 Aug 16 08:06 supported-entities.json
vagrant@vagrant:~$ 

```







### Start the Sirius Peer Daemon
This VM comes pre-installed with the Debian Binary of the Sirius Blockchain Peer.  The executable is already in the bin folder.  Go ahead and start the Sirius daemon:

```bash
sudo sirius.bc /etc/sirius/chain/
```









### Marvel at the chain's behaviour
Once executed, you can easily witness a new chain will be created every 15 seconds by default and the log entry looks like this:
```bash


2019-08-20 10:29:31.094175 0x00007f723fa60700: <info> (chain::RemoteApiForwarder.h@66) completed 'synchronizer task' (api2uswest2 @ XXXX:7900) with result Success 
2019-08-20 10:29:35.932941 0x00007f723fa60700: <info> (src::DiagnosticsService.cpp@39) --- current counter values ---
  MEM CUR RSS : 118
  MEM MAX RSS : 118
 MEM CUR VIRT : 919
  MEM SHR RSS : 37
TOT CONF TXES : 114872
     ACNTST C : 46
 ACNTST C HVA : 31
     BLKDIF C : 526
       HASH C : 77567
 SECRETLOCK C : 0
     CONFIG C : 1
   CONTRACT C : 0
 REPUTATION C : 0
     MOSAIC C : 5
   MULTISIG C : 0
   METADATA C : 0
   HASHLOCK C : 0
    UPGRADE C : 1
         NS C : 1
      NS C AS : 6
      NS C DS : 6
   PROPERTY C : 0
     UT CACHE : 0
    B WRITERS : 0
      WRITERS : 5
 BLK ELEM TOT : 5
 BLK ELEM ACT : 1
  TX ELEM TOT : 0
  TX ELEM ACT : 0
RB COMMIT ALL : 0
RB COMMIT RCT : 0
RB IGNORE ALL : 0
RB IGNORE RCT : 0
 UNLKED ACCTS : 0
TS OFFSET ABS : 0
TS OFFSET DIR : 0
  TS NODE AGE : 0
 TS TOTAL REQ : 0
 ACTIVE PINGS : 0
  TOTAL PINGS : 0
SUCCESS PINGS : 0
      READERS : 0
        TASKS : 12 

2019-08-20 10:29:37.009770 0x00007f722d0ab700: <info> (disruptor::ConsumerDispatcher.cpp@43) completing processing of element 5 (400 blocks (heights 19602 - 20001) [862C1F55] from Remote_Pull), last consumer is 0 elements behind 
2019-08-20 10:29:39.896084 0x00007f723fa60700: <info> (ionet::PacketSocket.cpp@450) connected to XXXX [XXXX:7900]
```



...also observe the Blockchain's height increasing:
```

(disruptor::ConsumerDispatcher.cpp@43) completing processing of element 22 (3 blocks (heights 10725 - 10727) [FBD6794A] from Remote_Pull), last consumer is 0 elements behind 
```


Take note of the "heights" statement in the logs, which shows that the blockchain creates new blocks every 15 seconds (by default).




 


