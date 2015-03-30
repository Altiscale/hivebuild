#!/bin/sh -ex
# build the artifacts using the hive ant build
# set the hadoop version for the lowest common denominator and let it be overridden by env
# sepcify $ADDITIONAL_OPTIONS for any fixed options "-Dskip.javadoc=true", for instance
#export HADOOP_VERSION=${HADOOP_VERSION:-2.0.5-alpha}
#export HIVE_ORC_PROTO_FILE=${HIVE_ORC_PROTO_FILE:-${WORKSPACE}/hive/ql/src/protobuf/org/apache/hadoop/hive/ql/io/orc/orc_proto.proto}
#export HIVE_ORC_SRC_DIR=${HIVE_ORC_SRC_DIR:-${WORKSPACE}/hive/ql/src/protobuf/org/apache/hadoop/hive/ql/io/orc}
#export HIVE_ORC_DST_DIR=${HIVE_ORC_DST_DIR:-${WORKSPACE}/hive/ql/src/gen/protobuf/gen-java}
#if [[ -z "$HADOOP_PROTOC_PATH" ]]
#then
#  echo "Skipping protobuf compilation as HADOOP_PROTOC_PATH is null."
#else
#	$HADOOP_PROTOC_PATH -I=$HIVE_ORC_SRC_DIR --java_out=$HIVE_ORC_DST_DIR $HIVE_ORC_PROTO_FILE
#fi

#refixing wb-803 for wb-505, this would need to be a community patch, and this is  already changed in hive-0.11
#export ANT_OPTS="-XX:MaxPermSize=512m -Xmx1024m"
mvn -X -e -U install -Pdist -DskipTests -Phadoop-2 -DcreateChecksum=true
