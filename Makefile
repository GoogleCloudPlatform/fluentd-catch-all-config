# package google-fluentd configuration files.

BASE_PACKAGE_NAME=google-fluentd
PACKAGE_NAME=${BASE_PACKAGE_NAME}-catch-all-config
PACKAGE_VERSION=0.1

BUILD_DIR=build

DEB_PACKAGE_DIR=${BUILD_DIR}/deb/${PACKAGE_NAME}-${PACKAGE_VERSION}
DEB_FILES_DIR=${DEB_PACKAGE_DIR}/files/etc/${BASE_PACKAGE_NAME}

EL_FILES_DIR=${BUILD_DIR}/el/${PACKAGE_NAME}-${PACKAGE_VERSION}/files

all: deb tar

# The config file needs to be renamed with a .google extension to permit
# a diversion from the original to be installed.
deb: populate-deb
	cp -a pkg/deb/debian ${DEB_PACKAGE_DIR}
	mv ${DEB_FILES_DIR}/google-fluentd.conf ${DEB_FILES_DIR}/google-fluentd.conf.google
	(cd ${DEB_PACKAGE_DIR} && debuild --no-tgz-check -us -uc)
	mv ${DEB_FILES_DIR}/google-fluentd.conf.google ${DEB_FILES_DIR}/google-fluentd.conf

tar: deb-tar el-tar

# tarfile for Debian systems
deb-tar: populate-deb
	tar --owner=root --group=root -C ${DEB_FILES_DIR} \
	    -czf ${PACKAGE_NAME}_${PACKAGE_VERSION}.deb.tar.gz .

# tarfile for Red Hat systems
el-tar: populate-el
	tar --owner=root --group=root -C ${EL_FILES_DIR} \
	    -czf ${PACKAGE_NAME}-${PACKAGE_VERSION}.el.tar.gz .

populate-deb:
	mkdir -p ${DEB_FILES_DIR}
	cp -a configs/* ${DEB_FILES_DIR}

# Note: collect /var/log/messages on RH since syslog does not exist.
populate-el:
	mkdir -p ${EL_FILES_DIR}
	cp -a configs/* ${EL_FILES_DIR}
	sed -i -e 's/path \/var\/log\/syslog/path \/var\/log\/messages/' \
	    ${EL_FILES_DIR}/catch-all-inputs.d/syslog.conf

clean:
	rm -rf *.tar.gz ${BUILD_DIR}
