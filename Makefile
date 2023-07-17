TAG=enexa-dice-embeddings:latest

build:
	docker build -t $(TAG) .

test:
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-v ~/.local/share/dicee/KGs:/dicee/KGs \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test/update \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/writeable \
	-e ENEXA_MODULE_INSTANCE_IRI=http://dbpedia.org/resource/Lagomorpha \
	--network enexa-utils_default \
	$(TAG)
