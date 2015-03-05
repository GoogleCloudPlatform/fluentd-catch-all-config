# package google-fluentd configuration files.

PACKAGE_NAME=google-fluentd-catch-all-config

tar:
	tar --owner=root --group=root -C configs -czvf \
	    ${PACKAGE_NAME}.tar.gz .


