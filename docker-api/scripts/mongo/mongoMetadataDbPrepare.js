(function prepareMetadataCollections() {
	db.createCollection('metadatas');
	db.metadatas.createIndex({ 'metadata.metadataId': 1 }, { unique: true });

	db.metadatas.getIndexes();
})();
