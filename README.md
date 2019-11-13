# Onboarding the Community into ProximaX Sirius MAINNET

This readme contains the official ProximaX instructions on how to use the community distribution for a Sirius Blockchain Peer.  The deployable Peer automatically hooks-up to ProximaX MAINNET, provided you have setup the harvesterKey.

For creation of your own harvestKey, please follow wiki guide here:  [Create your own MAINNET HarvestKey](https://github.com/proximax-storage/community-onboarding/wiki/Creating-your-MAINNET-HarvestKey-using-the-ProximaX-WALLET) 

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
mkdir -m 777 ~/proximax-community-peer-mainnet
cd ~/proximax-community-peer-mainnet
wget https://proximax-vagrant-storage.s3-ap-southeast-1.amazonaws.com/proximax-sirius-peer-v0.4.3.box
```


Once download completes, setup your vagrant environment to point to the boxfile, then initiatize it:
```bash
vagrant box add proximax-community-peer-v0.4.3 proximax-sirius-peer-v0.4.3.box
vagrant init proximax-community-peer-v0.4.3
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


Once inside the VM, please take note of the following executable PATH:

```bash
#check Sirius Blockchain executable:

vagrant@vagrant:~$ which sirius.bc
/usr/bin/sirius.bc




```



### Sirius BlockChain Config Files for MAINNET
Inspect the path of the config files of your Sirius Peer Node (located in path /etc/sirius/chain/mainnet/resources/) :
```bash


vagrant@vagrant:~$ ls -la /etc/sirius/chain/mainnet/resources/
total 108
drwxr-xr-x 2 vagrant 1001  4096 Nov 13 07:48 .
drwxr-xr-x 3 vagrant 1001  4096 Nov 13 07:44 ..
-rw-r--r-- 1 vagrant 1001   656 Nov 11 08:13 config-database.properties
-rw-r--r-- 1 vagrant 1001   213 Nov 11 08:13 config-extensions-broker.properties
-rw-r--r-- 1 vagrant 1001   216 Nov 11 08:13 config-extensions-recovery.properties
-rw-r--r-- 1 vagrant 1001   692 Nov 11 08:13 config-extensions-server.properties
-rw-r--r-- 1 vagrant 1001   252 Nov 13 07:48 config-harvesting.properties
-rw-r--r-- 1 vagrant 1001   416 Nov 11 08:14 config-immutable.properties
-rw-r--r-- 1 vagrant 1001    67 Nov 11 08:14 config-inflation.properties
-rw-r--r-- 1 vagrant 1001   370 Nov 11 08:14 config-logging-broker.properties
-rw-r--r-- 1 vagrant 1001   372 Nov 11 08:25 config-logging-recovery.properties
-rw-r--r-- 1 vagrant 1001   370 Nov 11 08:15 config-logging-server.properties
-rw-r--r-- 1 vagrant 1001    35 Nov 11 08:15 config-messaging.properties
-rw-r--r-- 1 vagrant 1001    29 Nov 11 08:15 config-networkheight.properties
-rw-r--r-- 1 vagrant 1001  2575 Nov 11 08:25 config-network.properties
-rw-r--r-- 1 vagrant 1001  1524 Nov 11 08:15 config-node.properties
-rw-r--r-- 1 vagrant 1001    76 Nov 11 08:15 config-pt.properties
-rw-r--r-- 1 vagrant 1001  1098 Nov 11 08:15 config-task.properties
-rw-r--r-- 1 vagrant 1001    37 Nov 11 08:15 config-timesync.properties
-rw-r--r-- 1 vagrant 1001   266 Nov 13 07:45 config-user.properties
-rw-r--r-- 1 vagrant 1001  7491 Nov 11 08:15 peers-api.json
-rw-r--r-- 1 vagrant 1001 13754 Nov 11 08:15 peers-p2p.json
-rw-r--r-- 1 vagrant 1001  2020 Nov 11 08:15 supported-entities.json
vagrant@vagrant:~$ 


```







### Start the Sirius Peer Daemon
This VM comes pre-installed with the Debian Binary of the Sirius Blockchain Peer.  The executable is already in the bin folder.  Go ahead and start the Sirius daemon:

```bash
sudo sirius.bc /etc/sirius/chain/mainnet/
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




 


