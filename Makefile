VERSION = "v0.0.6" 
IM=matentzn/vfb-neo2owl-test
OUTDIR=/Users/matentzn/pipeline/vfb-pipeline-neo2owl-test/data
FILENAME_LOCAL=o_local.owl
FILENAME_REMOTE=o_remote.owl
TESTIRI=https://raw.githubusercontent.com/matentzn/ontologies/master/issue2_neo2owl.owl
NEODIR="/Users/matentzn/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-cbde95fd-fdd9-43b0-a4bb-764de88b716b/installation-3.3.3/"

docker-build:
	@docker build -t $(IM):$(VERSION) . \
	&& docker tag $(IM):$(VERSION) $(IM):latest
	
docker-build-no-cache:
	@docker build --no-cache -t $(IM):$(VERSION) . \
	&& docker tag $(IM):$(VERSION) $(IM):latest

docker-run:
	docker run --volume $(OUTDIR):/out --volume $(NEODIR):/localneo --env-file ./env.list $(IM)
