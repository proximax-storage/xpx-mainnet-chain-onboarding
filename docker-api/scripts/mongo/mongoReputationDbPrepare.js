(function prepareReputationCollections() {
	db.createCollection('reputations');
	db.reputations.createIndex({ 'reputation.account': 1 }, { unique: true });
	db.reputations.createIndex({ 'reputation.accountAddress': 1 }, { unique: true });

	db.reputations.getIndexes();
})();
