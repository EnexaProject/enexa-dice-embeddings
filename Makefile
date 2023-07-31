TAG=enexa-dice-embeddings:latest

DOCKER_NETWORK=enexa-utils_default
SHARED_DIR=$(PWD)/test-shared-dir
ID=mi-$(shell date +%s)
ENEXA_SHARED_DIRECTORY=/shared
ENEXA_WRITEABLE_DIRECTORY=$(ENEXA_SHARED_DIRECTORY)/writeable
ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test
ENEXA_MODULE_INSTANCE_IRI=http://example.org/$(ID)

build:
	docker build -t $(TAG) .

test: $(SHARED_DIR)/KGs
	# things which ENEXA is supposed to do
	echo "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX enexa: <http://w3id.org/dice-research/enexa/ontology#> INSERT DATA { <$(ENEXA_MODULE_INSTANCE_IRI)> <http://example.org/dicee/parameters/path_dataset_folder> <http://example.org/diceeKGs/UMLS> ; <http://example.org/dicee/parameters/model> <http://example.org/dicee/models/TransE> ; <http://example.org/dicee/parameters/num_epochs> 10 ; <http://example.org/dicee/parameters/embedding_dim> 2 . <http://example.org/diceeKGs/UMLS> enexa:location 'enexa-dir://KGs/UMLS' . <http://example.org/dicee/models/TransE> rdf:value 'TransE' }" |docker run -i --attach STDIN --rm --network $(DOCKER_NETWORK) $(TAG) sparql-update "$(ENEXA_META_DATA_ENDPOINT)"

	docker run --rm \
	-v $(SHARED_DIR):$(ENEXA_SHARED_DIRECTORY) \
	-e ENEXA_SERVICE_URL=http://enexa:36321/ \
	-e ENEXA_SHARED_DIRECTORY=$(ENEXA_SHARED_DIRECTORY) \
	-e ENEXA_WRITEABLE_DIRECTORY=$(ENEXA_WRITEABLE_DIRECTORY) \
	-e ENEXA_META_DATA_ENDPOINT=$(ENEXA_META_DATA_ENDPOINT) \
	-e ENEXA_MODULE_INSTANCE_DIRECTORY=$(ENEXA_WRITEABLE_DIRECTORY)/$(ID) \
	-e ENEXA_MODULE_INSTANCE_IRI=$(ENEXA_MODULE_INSTANCE_IRI) \
	--network $(DOCKER_NETWORK) \
	$(TAG)

$(SHARED_DIR)/KGs:
	mkdir -p $(SHARED_DIR)
	wget -O $(SHARED_DIR)/KGs.zip https://hobbitdata.informatik.uni-leipzig.de/KG/KGs.zip
	unzip $(SHARED_DIR)/KGs.zip -d $(SHARED_DIR)
