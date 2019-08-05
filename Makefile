test: 
	
# Building docker image
VERSION = "v0.0.6" 
IM=matentzn/vfb-neo2owl-test
PW=neo
OUTDIR=/data/pipeline2
#SERVER=http://host.docker.internal:7474
SERVER=http://kb.p2.virtualflybrain.org
FILENAME=ontology3.owl
TESTIRI=https://raw.githubusercontent.com/matentzn/ontologies/master/issue2_neo2owl.owl

docker-build:
	@docker build --no-cache -t $(IM):$(VERSION) . \
	&& docker tag $(IM):$(VERSION) $(IM):latest
	
docker-build-use-cache:
	@docker build -t $(IM):$(VERSION) . \
	&& docker tag $(IM):$(VERSION) $(IM):latest



docker-run:
	docker run --volume $(OUTDIR):/out --env=KBserver=$(SERVER) --env=KBpassword=$(PW) --env=FILENAME=$(FILENAME) $(IM)
	#robot diff --left-iri $(TESTIRI) --right $(OUTDIR)/$(FILENAME) -o $(OUTDIR)/diff_$(FILENAME).txt


docker-clean:
	docker kill $(IM) || echo not running ;
	docker rm $(IM) || echo not made 

docker-publish-no-build:
	@docker push $(IM):$(VERSION) \
	&& docker push $(IM):latest
	
docker-publish: docker-build-use-cache
	@docker push $(IM):$(VERSION) \
	&& docker push $(IM):latest
