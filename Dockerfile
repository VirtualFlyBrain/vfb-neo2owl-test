FROM python:3.6

VOLUME /logs
VOLUME /out
VOLUME /localneo

ENV WORKSPACE=/opt/VFB
ENV VOLUMEDATA=/out
ENV LOCALNEOINSTALL=/localneo

ENV CHUNK_SIZE=1000
ENV PING_SLEEP=120s
ENV BUILD_OUTPUT=${WORKSPACE}/build.out

RUN pip3 install wheel requests psycopg2 pandas

RUN apt-get -qq update || apt-get -qq update && \
apt-get -qq -y install git curl wget default-jdk pigz maven libpq-dev python-dev tree gawk jq

ENV PATH "/opt/VFB/:$PATH"

ENV ROBOT v1.6.0

ENV KBserverRemote=http://192.168.0.1:7474
ENV KBuserRemote=neo4j
ENV KBpasswordRemote=password
ENV KBserverLocal=http://192.168.0.1:7474
ENV KBuserLocal=neo4j
ENV KBpasswordLocal=password

ENV GITBRANCH=kbold2new

RUN wget -P ${WORKSPACE} https://raw.githubusercontent.com/ontodev/robot/master/bin/robot

RUN wget -P ${WORKSPACE} https://github.com/ontodev/robot/releases/download/$ROBOT/robot.jar

COPY process.sh /opt/VFB/process.sh

RUN chmod +x /opt/VFB/*.sh

RUN chmod +x /opt/VFB/robot

RUN echo -e "travis_fold:start:processLoad" && \
cd "${WORKSPACE}" && \
echo '** Git checkout VFB_neo4j **' && \
git clone --quiet https://github.com/VirtualFlyBrain/VFB_neo4j.git

RUN cd ${WORKSPACE} && \
echo -e "travis_fold:end:processLoad"

ADD test-queries /opt/VFB/test-queries
ADD kb-save.json /opt/VFB/kb-save.json
ADD kb-import.json /opt/VFB/kb-import.json

ENV PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

CMD ["/opt/VFB/process.sh"]
