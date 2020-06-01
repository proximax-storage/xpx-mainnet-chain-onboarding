(function prepareContractCollections() {
	db.createCollection('contracts');
	db.contracts.createIndex({ 'contract.multisig': 1 }, { unique: true });
	db.contracts.createIndex({ 'contract.multisigAddress': 1 }, { unique: true });

	db.contracts.getIndexes();
})();
