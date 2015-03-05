# package google-fluentd configuration files.

PACKAGE_NAME=google-fluentd-catch-all-config
PACKAGE_VERSION=0.1

tar: deb-tar el-tar

# tarfile for Debian systems
deb-tar: populate-deb
	tar --owner=root --group=root -C ${DEB_FILES} \
	    -czf ${PACKAGE_NAME}_${PACKAGE_VERSION}.deb.tar.gz .

# tarfile for Red Hat systems
el-tar: populate-el
	tar --owner=root --group=root -C ${EL_FILES} \
	    -czf ${PACKAGE_NAME}-${PACKAGE_VERSION}.el.tar.gz .

DEB_FILES=pkg/deb/${PACKAGE_NAME}-${PACKAGE_VERSION}/files
EL_FILES=pkg/el/${PACKAGE_NAME}-${PACKAGE_VERSION}/files

populate-deb:
	mkdir -p ${DEB_FILES}
	cp -a configs/* ${DEB_FILES}

# Note: collect /var/log/messages on RH since syslog does not exist.
populate-el:
	mkdir -p ${EL_FILES}
	cp -a configs/* ${EL_FILES}
	sed -i -e 's/path \/var\/log\/syslog/path \/var\/log\/messages/' \
	    ${EL_FILES}/catch-all-inputs.d/syslog.conf

clean:
	rm -rf *.tar.gz ${DEB_FILES} ${EL_FILES}
