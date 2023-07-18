TAG=enexa-dice-embeddings:latest

build:
	docker build -t $(TAG) .

test: test-shared-dir/KGs
	docker run --rm \
	-v $(PWD)/test-shared-dir:/shared \
	-e ENEXA_SHARED_DIRECTORY=/shared \
	-v ~/.local/share/dicee/KGs:/dicee/KGs \
	-e ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_WRITEABLE_DIRECTORY=/shared/writeable \
	-e ENEXA_MODULE_INSTANCE_IRI=http://example.org/moduleinstance-$$(date +%s) \
	--network enexa-utils_default \
	$(TAG)

test-shared-dir/KGs:
	mkdir -p test-shared-dir
	wget -O test-shared-dir/KGs.zip https://hobbitdata.informatik.uni-leipzig.de/KG/KGs.zip
	unzip test-shared-dir/KGs.zip -d test-shared-dir
