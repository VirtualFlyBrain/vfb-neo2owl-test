set -e

DEFAULT_URL='N2O_ONTOLOGY_URL'
DEFAULT_CONFIG='N2O_CONFIG'
IMPORT=http://ts.p2.virtualflybrain.org/rdf4j-server/repositories/vfb?query=PREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+obo%3A+%3Chttp%3A%2F%2Fpurl.obolibrary.org%2Fobo%2F%3E%0ACONSTRUCT+%7B%3Fx+%3Fy+%3Fz%7D%0AWHERE+%7B%0A%09%3Fx+%3Fy+%3Fz+.%0A%7D%0A
IMPORT_CONFIG=https://raw.githubusercontent.com/VirtualFlyBrain/neo4j2owl/master/src/test/resources/configs.yaml
server=http://host.docker.internal:7474
user=neo4j
password=neo

QUERY=import_ontology_transaction.neo4j

echo "* Preparing command *"
echo $IMPORT
CMD1='s,'${DEFAULT_URL}','${IMPORT}',g'
sed -i ${CMD1} ${QUERY}
CMD2='s,'${DEFAULT_CONFIG}','${IMPORT_CONFIG}',g'
sed -i ${CMD2} ${QUERY}

cat $QUERY

echo "${server}/db/data/transaction/commit"

curl -i -X POST ${server}/db/data/transaction/commit -u ${user}:${password} -H 'Content-Type: application/json' -d "@${QUERY}"
