
set -e

KB=http://kb.p2.virtualflybrain.org/db/data/transaction/commit
#KB=http://localhost:7474/db/data/transaction/commit
user=neo4j
pw=vfb
NEODIR="/Users/matentzn/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-f7c0d058-01bd-491e-ae1b-11c580bbe29d/installation-3.4.0/"
LOCALIMPORTDIR=$NEODIR"import"
LOCALLOGSDIR=$NEODIR"logs"
LOCALDATADIR=$NEODIR"data/databases/graph.db"
KBserverLocal=http://localhost:7474
KBuserLocal=neo4j
KBpasswordLocal=neo

curl -X POST $KB -u $user:$pw -H 'Content-Type: application/json' -d "@kb-save.json" -o kb.json
sh run.sh jq -r '[.results[].data[].row[]][0]' kb.json > kb.owl

#echo '** Importing the KB.owl from remote into a local instance **'
#rm -rf "$LOCALDATADIR"
#rm -rf "$LOCALLOGSDIR"/*
#rm -rf "$LOCALIMPORTDIR"/*
#cp kb.owl "$LOCALIMPORTDIR"
#curl -i -X POST ${KBserverLocal}/db/data/transaction/commit -u ${KBuserLocal}:${KBpasswordLocal} -H 'Content-Type: application/json' -d "@kb-import.json" -o kb-import-return.json

#echo '** Exporting the KB (again), bit this time from the local instance **'
#curl -X POST ${KBserverLocal}/db/data/transaction/commit -u ${KBuserLocal}:${KBpasswordLocal} -H 'Content-Type: application/json' -d "@kb-save.json" -o ont.json
#sh run.sh jq -r '[.results[].data[].row[]][0]' ont.json > ont.owl

