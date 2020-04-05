#!/bin/bash

set -e 

SCRIPTS=${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/
VFB_NEO4J_SRC=${WORKSPACE}/VFB_neo4j
LOCALIMPORTDIR=/localneo/import
LOCALLOGSDIR=/localneo/logs
LOCALDATADIR=/localneo/data/databases/graph.db
TESTQUERIES=/opt/VFB/test-queries

echo "Updateing Neo4J VFB codebase"
cd $VFB_NEO4J_SRC
git pull origin master
git checkout ${GITBRANCH}
git pull

cd ${WORKSPACE}

echo '** Exporting KB from the Remote Server to OWL **'
#python3 ${SCRIPTS}neo4j_kb_export.py ${KBserverRemote} ${KBuserRemote} ${KBpasswordRemote} ${OUT_FILE}

curl -X POST ${KBserverRemote}/db/data/transaction/commit -u ${KBuserRemote}:${KBpasswordRemote} -H 'Content-Type: application/json' -d "@kb-save.json" -o /out/kb.json
jq -r '[.results[].data[].row[]][0]' /out/kb.json > /out/kb.owl

echo '** Importing the KB.owl from remote into a local instance **'
rm -rf "${LOCALDATADIR}"
rm -rf "${LOCALLOGSDIR}"/*
rm -rf "${LOCALIMPORTDIR}"/*
cp /out/kb.owl /localneo/import
curl -i -X POST ${KBserverLocal}/db/data/transaction/commit -u ${KBuserLocal}:${KBpasswordLocal} -H 'Content-Type: application/json' -d "@kb-import.json" -o /out/kb-local-import.json

echo '** Exporting the KB (again), bit this time from the local instance **'
curl -X POST ${KBserverLocal}/db/data/transaction/commit -u ${KBuserLocal}:${KBpasswordLocal} -H 'Content-Type: application/json' -d "@kb-save.json" -o /out/kb2.json
jq -r '[.results[].data[].row[]][0]' /out/kb2.json > /out/kb2.owl

robot diff --left /out/kb2.owl --right /out/kb.owl -o /out/kb_diff.txt


echo '** Running a few test queries and ensure they yield the same results **'
ls -l ${TESTQUERIES}
for i in ${TESTQUERIES}/*.json; do
    [ -f "$i" ] || break
    echo $i
    fn=$(basename "$i" ".json")
    curl -X POST ${KBserverLocal}/db/data/transaction/commit -u ${KBuserLocal}:${KBpasswordLocal} -H 'Content-Type: application/json' -d "@${i}" -o /out/${fn}"_local.json"
    curl -X POST ${KBserverRemote}/db/data/transaction/commit -u ${KBuserRemote}:${KBpasswordRemote} -H 'Content-Type: application/json' -d "@${i}" -o /out/${fn}"_remote.json"
done