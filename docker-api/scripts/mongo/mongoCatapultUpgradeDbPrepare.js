(function prepareCatapultUpgradeCollections() {
    db.createCollection('catapultUpgrades');
    db.catapultUpgrades.createIndex({ 'catapultUpgrade.height': 1 }, { unique: true });

    db.catapultUpgrades.getIndexes();
})();
