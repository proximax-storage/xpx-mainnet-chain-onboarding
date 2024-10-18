# Get Started

The Sirius Storage Tool is a user desktop app to interact with Sirius Storage.

## Download
[Windows](https://files.proximax.io/storage-tool/windows-storage-tool.zip)
[Linux](https://files.proximax.io/storage-tool/linux-storage-tool.tar.xz)

## Installation

### Windows
1. Open `file explorer` and find the `windows-storage-tool.zip` zipped file
2. To unzip the file, double-click the zipped folder to open it. Then, drag or copy the item from the zipped folder to a new location
3. Go to the new location and enter the `windows-storage-tool` folder.
4. Double click on `StorageClientApp.exe` to run it.

**Note**: You may be prompted by Windows that Microsoft Defender SmartScreen is preventing this unrecognized app from Starting.  Click on `More Info` and click on the `Run Anyway` button.

### Ubuntu Linux
1. Open your linux terminal
2. Run the following commands to download and install the storage tool:

```bash
wget https://files.proximax.io/storage-tool/linux-storage-tool.tar.xz
tar -xvf linux-storage-tool.tar.xz
cd linux-storage-tool
./StorageClientApp
```


## Initial set up

1. Enter `Account name` and `Private Key`.  Click on `Generate Key` if you wish to use a new private key.  Please ensure the account has `XPX`.  As a security good practice, use the [web-wallet](https://web-wallet.xpxsirius.io) to transfer XPX from your personal account to this account.

2. Enter the following information for settings:

- REST Server Address: `arcturus.xpxsirius.io:3000`

- Replicator Bootstrap Address: `replicator-1.dfms.io:7904`
- Local UDP Port: `6846` (Default Port)
- Account Name: **Select the Account Name is Step 1**
- Download folder: **Click `Choose Directory` to select the directory you want to download files from drives**
- Fee Multiplier: `140000` (default fee multiplier for *Mainnet*)

## Creating Drive

1. In the main page, select `Drives` page tab.
2. Click `+` to create a new Drive.
3. Enter a name for the Drive you wish to create
4. Replicator Number should be set to `4`.
5. Max Drive Size (MB) should not be larger than 500MB.
6. Click `Choose Directory` to select a local drive folder to sync with your storage drive.
