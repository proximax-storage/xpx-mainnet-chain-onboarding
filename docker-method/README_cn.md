# ProximaX 天狼星 主网节点搭建

~~# ProximaX Sirius MAINNET Onboarding~~

## 操作系统要求

~~## OS Requirements~~

确认你的内网允许 流入/流出 这些端口的流量

~~Ensure that your local network allows inbound/outbound traffic on these ports:~~
- 3000/tcp
- 7900/tcp
- 7901/tcp
- 7902/tcp

系统要求的说明：

~~A note on System Requirements:~~

从理论上讲，此docker化的天狼星节点软件包可以在任何运行Docker 19.03.3版和docker-compose 1.24.0版的操作系统上运行。

~~Theoretically, this dockerized Sirius Peer package can run on any OS running Docker version 19.03.3 and docker-compose version 1.24.0.~~

但是，如果您确实需要最低基准，我们已经看到天狼星区块链节点可以在最低硬件为1个CPU内核和2GB RAM的情况下工作。

~~But if you really need a minimum benchmark, we have seen the Sirius Blockchain Peer to work with a minimum Hardware of 1 CPU core and 2GB RAM.~~

此帮助文档准备在以下环境进行包测试：

~~This README was prepared by testing the package on:~~
- Debian 10 ++
- Ubuntu 19.04 ++
- CentOS 7 ++

## 前提条件

~~## Pre-requisite~~

这种搭建方法需要`docker`和`docker-compose`。

~~This onboarding method requires `docker` and `docker-compose`.~~  

执行下列语句来安装“docker”

~~Run the following command to install `docker`:~~
```
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sh get-docker.sh
```

根据Docker安装后的说明，我们建议使用Docker作为非root用户。因此，您现在应该考虑使用以下方式将用户添加到“ docker”组：

~~As per docker post-installation note, we recommend using Docker as a non-root user.  Therefore, you should now consider adding your user to the "docker" group with something like:~~
```
$ sudo usermod -aG docker $your_user
```
请记住，您必须先注销然后重新登录才能生效

~~Remember that you will have to log out and back in for this to take effect!"~~

docker-compose的安装说明 [这里](https://docs.docker.com/compose/install/)

~~Installation instructions for docker-compose can be found [here](https://docs.docker.com/compose/install/).~~

开启和设置Docker的开机启动

~~Enable and start Docker:~~
```
$ sudo systemctl enable docker.service
$ sudo systemctl start docker.service
$ sudo systemctl status docker.service
```

## 下载和解压包

~~## Download and Extract the package~~
```
$ wget https://github.com/proximax-storage/xpx-mainnet-chain-onboarding/releases/download/release-v0.4.3-buster/public-mainnet-peer-package-v0.4.3.tar.gz
$ tar -xvf public-mainnet-peer-package-v0.4.3.tar.gz
$ cd public-mainnet-peer-package-v0.4.3
```

## 创建一个密钥对

~~## Generate a keypair~~
```
$ tools/gen_key_pair_addr
```

## 在[config-user.properties](resources/config-user.properties)中输入私钥

~~## Insert private key in [config-user.properties](resources/config-user.properties)~~

将`BOOTKEY_PRIVATE_KEY`替换为生成的私钥.这个账号持有节点声望

~~Replace `BOOTKEY_PRIVATE_KEY` with the generated private key. This is the account which holds the node reputation.~~
```
[account]

bootKey = BOOTKEY_PRIVATE_KEY 

[storage]

dataDirectory = /data
pluginsDirectory = 
```

## 在[config-node.properties](resources/config-node.properties)填一个友好的名字(可选的)

~~## Assign a friendly name in  [config-node.properties](resources/config-node.properties) (OPTIONAL)~~

将域名或公网IP地址添加到“host”参数，将其保留为空会自动检测。添加一个友好的名

~~Add the domain name or public IP address to the `host` parameter, leave empty to auto-detect.~~

字来为您的节点分配名称（例如：“mainnet-looneytoons-01”）。

~~Add a `friendlyName` to assign a name to your node (like: `mainnet-looneytoons-01`).~~
```
[localnode]

host =
friendlyName =
version = 0
roles = Peer
```

## 委托验证

~~## Delegated Validating~~

您可以通过运行以下工具来激活帐户以进行委托验证：

~~You may activate your account for delegated validating by running the following tool:~~
```
$ tools/delegated_validating_mainnet
```

执行上述工具后，在[config-harvesting.properties](resources/config-harvesting.properties)这里添加委托收获私钥

~~After running the above tool, add the delegated remote account private key in the [config-harvesting.properties](resources/config-harvesting.properties):~~
```
[harvesting]
# private keys are 64 characters
harvestKey = REMOTE_ACCOUNT_PRIVATE_KEY
beneficiary = 0000000000000000000000000000000000000000000000000000000000000000
isAutoHarvestingEnabled = true
maxUnlockedAccounts = 5
```

通过使用生成的交易哈希或您的帐户地址在线检查ProximaX [区块链浏览器]
（https://explorer.xpxsirius.io）

~~Verify that your account has successfully activated delegated validation by checking ProximaX online [explorer](https://explorer.xpxsirius.io) using the generated transaction hash or using your account address.~~

请注意，如果您的帐户没有任何XPX或先前已链接到另一个远程帐户，则该交易将失败。

~~Please note that if your account does not have any XPX or previously linked to another remote account, the transaction will be unsuccessful.~~

**有关更多信息，请阅读我们的在线文档[此处](https://bcdocs.xpxsirius.io/docs/protocol/validating/)**

~~**For more info, please read our online documentations [here](https://bcdocs.xpxsirius.io/docs/protocol/validating/)**~~

## 开启节点

~~## Start the Peer Node~~
```
$ docker-compose up -d
```

## 检查容器是否运行

~~## Check if container is running~~
```
$ docker container ls
```

## 停止节点

~~## Stop the Peer Node~~
```
$ docker-compose down
```

## 重启节点

~~## Restart the Peer Node~~
```
$ docker-compose restart
```

## 检查节点日志

~~## Check logs~~

有两种方法查看日志

~~There are 2 ways to view the logs:~~

1. docker日志

~~1. docker logs~~
```
$ docker-compose logs --tail=100 -f
```
按Ctrl-C 停止跟随输出日志

2. 在logs文件夹下的日志文件

~~2. log files in `logs` directory~~

## 创建服务，在重启后自动启动容器

~~## Create service and auto-start container on reboot~~
```
$ sudo nano /etc/systemd/system/sirius-chain-mainnet.service
```

将这段文字替换文件里的`PATH_OF_YML_FILE`

~~Put this text in this file and replace `PATH_OF_YML_FILE`:~~
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

```
$ sudo systemctl daemon-reload
$ sudo systemctl enable sirius-chain-mainnet
```

如果Docker容器没有运行，你可以使用以下命令启动容器：

~~If the Docker container isn't running yet, you can start the container using this command:~~
```
$ sudo systemctl start sirius-chain-mainnet
```

## 桌面维护团队

~~## Helpdesk~~

我们拥有[telegram桌面维护团队](https://t.me/proximaxhelpdesk)来支援一般咨询

~~We have a [telegram helpdesk](https://t.me/proximaxhelpdesk) to assist general queries.~~

更多关于验证节点的咨询，你可以在[ProximaX区块链验证节点组](https://t.me/xpxnetworkecosystem)讨论

~~For validation-specific queries, you may discuss it at [ProximaX Network Participants Group](https://t.me/xpxnetworkecosystem)~~
