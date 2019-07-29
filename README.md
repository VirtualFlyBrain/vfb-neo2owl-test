# Testing procedure

## Local
1. Make fix to neo2owl
1. Make sure no System.exit and System.out anywhere unintended. Make sure `private static boolean testmode = false;` in OWL2OntologyImporter.java.
1. Build using `clean compiler:compile package`
1. Run deploy.sh in neo4j2owl (new editor: need to update scripts with the correct paths). This copies the freshly build neo2owl.jar to some local neo4j instance. Note that this instance must be configured with `dbms.security.procedures.unrestricted=ebi.spot.neo4j2owl.*` and sufficient memory.
1. Run/restart the neo4j instance (localhost:7474)
1. In vfb-neo2owl-test, run `docker-run`. This will export whatever is loaded in the neo2owl instance as OWL into some specified (see Makefile) directory and runs a ROBOT diff.