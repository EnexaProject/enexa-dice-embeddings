TAG=enexa-dice-embeddings:latest

build:
	docker build -t $(TAG) .

test:
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-v ~/.local/share/dicee/KGs:/dicee/KGs \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/writeable \
	-e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-$$(date +%s) \
	--network enexa-utils_default \
	$(TAG)
