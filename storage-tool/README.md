# Get Started

The Sirius Storage Tool is a user desktop app to interact with Sirius Storage.

## Download
[Windows](https://files.proximax.io/storage-tool/windows-storage-tool.zip)
[Linux](https://files.proximax.io/storage-tool/linux-storage-tool.tar.xz)
[MacOS](https://files.proximax.io/storage-tool/macos-storage-tool.dmg)

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
- Fee Multiplier: `150000` (default fee multiplier for *Mainnet*)

## Creating Drive

![image](storage-tool-ui.png)
1. In the main page, select `Drives` page tab.
2. Click `+` to create a new Drive.
3. Enter a name for the Drive you wish to create
4. Replicator Number should be set to `4`.
5. Max Drive Size (MB) should not be larger than 500MB.
6. Click `Choose Directory` to select a local drive folder to sync with your storage drive.
7. When you are done, click **Confirm** button.
8. Your drive will now appear in the drop-down list of drives with (`creating...`) appended to its name, indicating that it has been ordered, but not created yet. You will receive a notification as soon as it is created.
9. When the drive is created, your files will appear in green color in the right half of the window. The right half represents the difference between your local drive and replicated drive. Click **Apply changes** button to upload the files to replicators.
10. When the modification is completed, your files will appear in the left half of the window, indicating that the replicated drive now contains them.

## Instruction Videos
[Initial instruction](https://youtu.be/euMrxMNK88o) - drive creation, uploading & deleting files

[Download instruction](https://youtu.be/vV6s8WzhZCk) - downloads from other drives by link

