(function prepareCatapultConfigCollections() {
    db.createCollection('catapultConfigs');
    db.catapultConfigs.createIndex({ 'catapultConfig.height': 1 }, { unique: true });

    db.catapultConfigs.getIndexes();
})();
