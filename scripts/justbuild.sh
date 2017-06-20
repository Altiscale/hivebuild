#!/bin/sh -ex
env
MVN_SKIPTESTS_BOOL=${SKIPTESTS_BOOL:-false}
if [ "${MVN_SKIPTESTS_BOOL}" != "true" ] ; then
    MVN_SKIPTESTS_BOOL=false
fi
# Build hive
mvn install -Pdist -Dmaven.test.skip=${MVN_SKIPTESTS_BOOL} -DskipTests=${MVN_SKIPTESTS_BOOL} -DcreateChecksum=true -Dmaven.javadoc.skip=true -Dmaven-javadoc-plugin=false
exit 1
