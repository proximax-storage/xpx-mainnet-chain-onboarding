# Upgrade Notes

## Upgrading to v1.9.6

Run the following commands to download and execute the `upgrade.sh` script:
```bash 
wget https://raw.githubusercontent.com/proximax-storage/xpx-mainnet-chain-onboarding/release-v1.9.6/scripts/upgrade.sh
chmod +x ./upgrade.sh
./upgrade.sh
```

Once the `upgrade.sh` script has completed the configuration, run the node with command:
```bash
cd $base_dir #where $base_dir is the directory of your node installation
docker-compose up -d
```
