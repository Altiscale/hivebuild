#!/bin/sh -ex
# deal with the hive artifacts to create a tarball ARTIFACT_VERSION is supplied by the ruby wrapper
env
ALTISCALE_RELEASE=${ALTISCALE_RELEASE:-0.1.0}
HIVE_VERSION=${ARTIFACT_VERSION:-0.11.0}
RPM_DESCRIPTION="Apache Hive ${HIVE_VERSION}\n\n${DESCRIPTION}\n"

#convert each tarball into an RPM
DEST_ROOT=${INSTALL_DIR}/opt
mkdir --mode=0755 -p ${DEST_ROOT}
cd ${DEST_ROOT}
tar -xvzpf ${WORKSPACE}/hive2/packaging/target/apache-hive-${HIVE_VERSION}-bin.tar.gz
tar -xvzpf ${WORKSPACE}/hive2/packaging/target/apache-hive-${HIVE_VERSION}-src.tar.gz
mv apache-hive-${HIVE_VERSION}-bin hive-${HIVE_VERSION}
mv apache-hive-${HIVE_VERSION}-src hive-${HIVE_VERSION}/src

mkdir --mode=0755 -p ${INSTALL_DIR}/etc
mv ${INSTALL_DIR}/opt/hive-${ARTIFACT_VERSION}/conf ${INSTALL_DIR}/etc/hive-${ARTIFACT_VERSION}
cd ${INSTALL_DIR}/opt/hive-${ARTIFACT_VERSION}
ln -s /etc/hive-${ARTIFACT_VERSION} conf

# convert all the etc files to config files
cd ${INSTALL_DIR}
export CONFIG_FILES=""
find etc -type f -print | awk '{print "/" $1}' > /tmp/$$.files
for i in `cat /tmp/$$.files`; do CONFIG_FILES="--config-files $i $CONFIG_FILES "; done
export CONFIG_FILES
rm -f /tmp/$$.files

cd ${RPM_DIR}

export RPM_NAME="alti-${PACKAGES}-${HIVE_VERSION}"
fpm --verbose \
--maintainer support@altiscale.com \
--vendor Altiscale \
--provides ${RPM_NAME} \
--description "$(printf "${RPM_DESCRIPTION}")" \
--url ${GITREPO} \
--license "Apache License v2" \
-s dir \
-t rpm \
-n ${RPM_NAME} \
-v ${ALTISCALE_RELEASE} \
--iteration ${DATE_STRING} \
${CONFIG_FILES} \
--rpm-user root \
--rpm-group root \
-C ${INSTALL_DIR} \
opt etc
