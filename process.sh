#!/bin/bash
OUT_FILE=/out/${FILENAME}
SCRIPTS=${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/
VFB_NEO4J_SRC=${WORKSPACE}/VFB_neo4j

echo "Updateing Neo4J VFB codebase"
cd $VFB_NEO4J_SRC
git pull origin master
git checkout ${GITBRANCH}
git pull

echo "Creating temporary directories.."
cd ${WORKSPACE}

echo '** Exporting Neo4J to OWL **'
echo ${KBserver}
echo ${OUT_FILE}
python3 ${SCRIPTS}neo4j_kb_export.py ${KBserver} ${KBuser} ${KBpassword} ${OUT_FILE}