
set -e

#KB=http://kb.p2.virtualflybrain.org/db/data/transaction/commit
#KB=http://localhost:7474/db/data/transaction/commit
KB=http://localhost:7474/db/data/transaction/commit
user=neo4j
pw=neo
NEODIR="/Users/matentzn/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases/database-f7c0d058-01bd-491e-ae1b-11c580bbe29d/installation-3.4.0/"
LOCALIMPORTDIR=$NEODIR"import"
LOCALLOGSDIR=$NEODIR"logs"
LOCALPLUGINDIR=$NEODIR"plugins"
LOCALDATADIR=$NEODIR"data/databases/graph.db"
KBserverLocal=http://localhost:7474
KBuserLocal=neo4j
KBpasswordLocal=neo
KB_RAW="/Users/matentzn/ws/kb2_data/data/databases/graph.db"
PLUGIN="/Users/matentzn/ws/neo4j2owl/target/neo4j2owl-1.0.jar"

#rm -rf "$LOCALDATADIR"
#rm -rf "$LOCALLOGSDIR"/*
#rm -rf "$LOCALIMPORTDIR"/*
#cp -r "$KB_RAW" "$LOCALDATADIR"
#cp -f "$PLUGIN" "$LOCALPLUGINDIR"

curl -X POST $KB -u $user:$pw -H 'Content-Type: application/json' -d "@kb-save.json" -o kb.json
sh run.sh jq -r '[.results[].data[].row[]][0]' kb.json > kb.owl