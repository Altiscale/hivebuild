#!/bin/sh -ex
# deal with the hive artifacts to create a tarball
ALTISCALE_RELEASE=${ALTISCALE_RELEASE:-0.1.0}

# convert each tarball into an RPM
DEST_ROOT=${INSTALL_DIR}/opt
mkdir --mode=0755 -p ${DEST_ROOT}
cd ${DEST_ROOT}
tar -xvzpf ${WORKSPACE}/hive/build/hive-${ARTIFACT_VERSION}.tar.gz
mkdir --mode=0755 -p ${INSTALL_DIR}/etc
mv ${INSTALL_DIR}/opt/hive-${ARTIFACT_VERSION}/conf ${INSTALL_DIR}/etc/hive-${ARTIFACT_VERSION}
cd ${INSTALL_DIR}/opt/hive-${ARTIFACT_VERSION}
ln -s /etc/hive-${ARTIFACT_VERSION} conf
cd ${INSTALL_DIR}/opt/hive-${ARTIFACT_VERSION}/lib
ln -s /opt/mysql-connector/mysql-connector.jar mysql-connector.jar

# wb-803 remove slf4j-log4j12-1.6.1.jar
rm ${INSTALL_DIR}/opt/hive*/lib/slf4j-log4j12-1.6.1.jar

# convert all the etc files to config files
cd ${INSTALL_DIR}
export CONFIG_FILES=""
find etc -type f -print | awk '{print "/" $1}' > /tmp/$$.files
for i in `cat /tmp/$$.files`; do CONFIG_FILES="--config-files $i $CONFIG_FILES "; done
export CONFIG_FILES
rm -f /tmp/$$.files


cd ${RPM_DIR}

export RPM_NAME=vcc-hive-${ARTIFACT_VERSION}
fpm --verbose \
--maintainer ops@verticloud.com \
--vendor VertiCloud \
--provides ${RPM_NAME} \
--description "${DESCRIPTION}" \
--depends alti-mysql-connector \
--replaces vcc-hive \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${RPM_VERSION} \
--iteration ${DATE_STRING} \
${CONFIG_FILES} \
--rpm-user root \
--rpm-group root \
-C ${INSTALL_DIR} \
opt etc
