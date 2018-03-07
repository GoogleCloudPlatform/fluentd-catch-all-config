# package google-fluentd configuration files.

BASE_PACKAGE_NAME=google-fluentd
PACKAGE_NAME=${BASE_PACKAGE_NAME}-catch-all-config-structured
PACKAGE_VERSION=0.7

BUILD_DIR=build

DEB_PACKAGE_DIR=${BUILD_DIR}/deb/${PACKAGE_NAME}-${PACKAGE_VERSION}
DEB_FILES_BASE=${DEB_PACKAGE_DIR}/files
DEB_FILES_DIR=${DEB_FILES_BASE}/etc/${BASE_PACKAGE_NAME}
DEB_POS_FILES_DIR=${DEB_FILES_BASE}/var/lib/${BASE_PACKAGE_NAME}/pos

RPM_PACKAGE_DIR=${BUILD_DIR}/el/${PACKAGE_NAME}-${PACKAGE_VERSION}
EL_FILES_BASE=${RPM_PACKAGE_DIR}/files
EL_FILES_DIR=${EL_FILES_BASE}/etc/${BASE_PACKAGE_NAME}
EL_POS_FILES_DIR=${EL_FILES_BASE}/var/lib/${BASE_PACKAGE_NAME}/pos

all: pkg tar

pkg: deb rpm

deb: populate-deb
	(cd pkg/deb/; \
		DEBMAIL="stackdriver-agents@google.com" DEBFULLNAME="Stackdriver Agents" \
		dch --package "${PACKAGE_NAME}" \
		-v "${PACKAGE_VERSION}" "Automated Build")
	cp -a pkg/deb/debian ${DEB_PACKAGE_DIR}
	(cd ${DEB_PACKAGE_DIR} && debuild --no-tgz-check -us -uc)

rpm: populate-el
	rpmbuild -v -bb --nodeps --target noarch --define "buildroot `pwd`/${RPM_PACKAGE_DIR}/files" --define "_rpmdir `pwd`/${BUILD_DIR}/el" --define "package_version ${PACKAGE_VERSION}" --define "package_build_num 1" "pkg/el/${PACKAGE_NAME}.spec"

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
	# populate config files
	mkdir -p ${DEB_FILES_DIR}
	cp -a configs/* ${DEB_FILES_DIR}
	# create the directory used for "pos_file"s
	mkdir -p ${DEB_POS_FILES_DIR}

populate-el:
	# populate config files
	mkdir -p ${EL_FILES_DIR}
	cp -a configs/* ${EL_FILES_DIR}
	# collect /var/log/messages on RH since syslog does not exist.
	sed -i -e 's/path \/var\/log\/syslog/path \/var\/log\/messages/' \
			${EL_FILES_DIR}/config.d/syslog.conf
	# create the directory used for "pos_file"s
	mkdir -p ${EL_POS_FILES_DIR}

clean:
	rm -rf *.tar.gz ${BUILD_DIR}
