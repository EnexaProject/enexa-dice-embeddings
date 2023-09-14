IMAGE=hub.cs.upb.de/enexa/images/enexa-dice-embeddings
VERSION=1.0.1
TAG=$(IMAGE):$(VERSION)


DOCKER_NETWORK=enexa-utils_default
SHARED_DIR=$(PWD)/test-shared-dir
ID=mi-$(shell date +%s)
ENEXA_SHARED_DIRECTORY=/shared
ENEXA_WRITEABLE_DIRECTORY=$(ENEXA_SHARED_DIRECTORY)/writeable
ENEXA_META_DATA_ENDPOINT=http://admin:admin@fuseki:3030/test
ENEXA_MODULE_INSTANCE_IRI=http://dice-research.org/$(ID)

GRAPH_STORE_POST=docker run --rm -i --attach STDIN --attach STDOUT --attach STDERR --network $(DOCKER_NETWORK) $(TAG) graph-store-post "$(ENEXA_META_DATA_ENDPOINT)"

build: module.ttl
	docker build -t $(TAG) .

test: $(SHARED_DIR)/KGs
	# things which ENEXA is supposed to do

	<module.ttl $(GRAPH_STORE_POST)
	<test.ttl perl -pe "BEGIN {undef $$/} s{\\[}{<$(ENEXA_MODULE_INSTANCE_IRI)>}; s{\\]}{}" |$(GRAPH_STORE_POST)
	echo "@prefix enexa: <http://w3id.org/dice-research/enexa/ontology#> . <http://example.org/enexa-files/UMLS> enexa:location 'enexa-dir://KGs/UMLS'" |$(GRAPH_STORE_POST)


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

push:
	docker push $(TAG)

push-latest:
	docker tag $(TAG) $(IMAGE):latest
	docker push $(IMAGE):latest

module.ttl: module.ttl.template Makefile
	echo "# Don't change this file! It is generated based on module.ttl.template." >$@
	sed 's/$$(VERSION)/$(VERSION)/g' $< | sed 's=$$(TAG)=$(TAG)=g' >>$@
