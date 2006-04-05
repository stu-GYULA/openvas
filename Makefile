include nessus.tmpl

ALLDEPS = nessus.tmpl

all: $(ALLDEPS) server sslstuff doc fetchtool


nessus.tmpl: nessus.tmpl.in configure VERSION
	$(SHELL) configure $(CONFIGURE_ARGS)
	touch $@

install: all install-bin install-man
	@echo
	@echo ' --------------------------------------------------------------'
	@echo ' openvas-core has been sucessfully installed. '
	@echo " Make sure that $(bindir) and $(sbindir) are in your PATH before"
	@echo " you continue."
	@echo " openvasd has been installed into $(sbindir)"
	@echo ' --------------------------------------------------------------'
	@echo

install-bin:
	test -d $(DESTDIR)${sbindir} || $(INSTALL_DIR) -m 755 $(DESTDIR)${sbindir}
	$(INSTALL) -m $(SERVERMODE)  ${make_bindir}/openvasd $(DESTDIR)${sbindir}
	$(INSTALL) -m $(SERVERMODE) ${make_bindir}/nessus-check-signature $(DESTDIR)${sbindir}
	test -d $(DESTDIR)${sysconfdir} || $(INSTALL_DIR) -m 755 $(DESTDIR)${sysconfdir}
	test -d $(DESTDIR)${sysconfdir}/nessus || $(INSTALL_DIR) -m 755 $(DESTDIR)${sysconfdir}/nessus	
	test -d $(DESTDIR)${NESSUSD_DATADIR} || \
		$(INSTALL_DIR) -m $(PLUGINSDIRMODE) $(DESTDIR)${NESSUSD_DATADIR}
	test -d $(DESTDIR)$(NESSUSD_PLUGINS) || \
		$(INSTALL_DIR) -m $(PLUGINSDIRMODE) $(DESTDIR)$(NESSUSD_PLUGINS)
	test -d $(DESTDIR)${includedir} || $(INSTALL_DIR) -m 755 $(DESTDIR)${includedir}
	test -d $(DESTDIR)${includedir}/nessus || $(INSTALL_DIR) -m 755 $(DESTDIR)${includedir}/nessus
	test -d $(DESTDIR)${localstatedir} || $(INSTALL_DIR) -m 755 $(DESTDIR)${localstatedir}
	test -d $(DESTDIR)${NESSUSD_STATEDIR} || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_STATEDIR}
	test -d $(DESTDIR)${NESSUSD_STATEDIR}/users || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_STATEDIR}/users
	test -d $(DESTDIR)${NESSUSD_STATEDIR}/logs  || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_STATEDIR}/logs
	test -d $(DESTDIR)${NESSUSD_STATEDIR}/tmp || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_STATEDIR}/tmp
	test -d $(DESTDIR)${NESSUSD_STATEDIR}/jobs  || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_STATEDIR}/jobs
	test -d $(DESTDIR)${NESSUSD_LOGDIR} || $(INSTALL_DIR) -m 755 $(DESTDIR)${NESSUSD_LOGDIR}
	$(INSTALL) -c -m 0444 openvas-services $(DESTDIR)${NESSUSD_STATEDIR}/
	$(INSTALL) -c -m 0444 include/config.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/ntcompat.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/includes.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessus-devel.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessusraw.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessusip.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessusicmp.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessustcp.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -c -m 0444 include/nessusudp.h $(DESTDIR)${includedir}/nessus
	$(INSTALL) -m 755 nessus-fetch/openvas-fetch $(DESTDIR)${bindir}
	$(INSTALL) -m 755 openvas-adduser $(DESTDIR)${sbindir}
	$(INSTALL) -m 755 openvas-rmuser $(DESTDIR)${sbindir}
	$(INSTALL) -m 755 openvas-mkcert $(DESTDIR)${sbindir}
	$(INSTALL) -m 755 openvas-mkcert-client $(DESTDIR)${bindir}
	$(INSTALL) -m 755 ssl/openvas-mkrand $(DESTDIR)${bindir}


install-man:
	@echo installing man pages ...
	@test -d $(DESTDIR)${mandir}/man1 || $(INSTALL_DIR) $(DESTDIR)${mandir}/man1
	@test -d $(DESTDIR)${mandir}/man8 || $(INSTALL_DIR) $(DESTDIR)${mandir}/man8

	$(INSTALL) -c -m 0444 doc/openvas-fetch.1 $(DESTDIR)${mandir}/man1/openvas-fetch.1
	$(INSTALL) -c -m 0444 doc/nessus-check-signature.1 $(DESTDIR)${mandir}/man1/nessus-check-signature.1
	$(INSTALL) -c -m 0444 ${MAN_NESSUSD_8} $(DESTDIR)${mandir}/man8/openvasd.8
	$(INSTALL) -c -m 0444 doc/openvas-adduser.8 $(DESTDIR)${mandir}/man8/openvas-adduser.8
	$(INSTALL) -c -m 0444 doc/openvas-rmuser.8 $(DESTDIR)${mandir}/man8/openvas-rmuser.8
	$(INSTALL) -c -m 0444 doc/openvas-mkcert.8 $(DESTDIR)${mandir}/man8/openvas-mkcert.8
	$(INSTALL) -c -m 0444 doc/openvas-mkcert-client.1 \
                              $(DESTDIR)${mandir}/man1/openvas-mkcert-client.1
	$(INSTALL) -c -m 0444 doc/openvas-mkrand.1 $(DESTDIR)${mandir}/man1/openvas-mkrand.1

server : 
	cd nessusd && $(MAKE)

sslstuff : 
	cd ssl && $(MAKE)


fetchtool:
	cd nessus-fetch && $(MAKE)


doc : $(MAN_NESSUSD_8)

$(MAN_NESSUSD_8) : $(MAN_NESSUSD_8).in
	@sed -e 's?@NESSUSD_CONFDIR@?${NESSUSD_CONFDIR}?g;s?@NESSUSD_DATADIR@?${NESSUSD_DATADIR}?g;s?@NESSUSD_PLUGINS@?${NESSUSD_PLUGINS}?g;' $(MAN_NESSUSD_8).in  >$(MAN_NESSUSD_8)


clean:
	cd nessus-fetch && $(MAKE) clean
	cd nessusd && $(MAKE) clean
	cd ssl && $(MAKE) clean

distclean: clean
	[ -z "${rootdir}" ] || rm -f ${rootdir}/include/config.h ${rootdir}/include/corevers.h 
	rm -f nessus.tmpl doc/nessus.1.cat doc/openvasd.8.cat
	[ -z "${make_bindir}" ] || rm -f $(make_bindir)/nessus* 
	rm -f libtool config.cache config.status config.log 
	rm -f openvas-adduser
	rm -f openvas-rmuser
	rm -f openvas-mkcert
	rm -f openvas-mkcert-client
	rm -f nessus-install-cert
	[ -z "${MAN_NESSUSD_8}" ] || rm -f ${MAN_NESSUSD_8} 

dist:
	version="`date +%Y%m%d`"; \
	cd ..; \
	tar cf openvas-core-$${version}.tar \
		`cat openvas-core/MANIFEST | sed 's/^/openvas-core\//'`; \
	rm -f openvas-core-$${version}.tar.gz; \
	gzip -9 openvas-core-$${version}.tar

distcheck:
	find . -type f | sed -e 's/^.\///' -e '/~$$/d' -e '/CVS/d' \
			     -e '/\.o$$/d' -e '/^nessus.tmpl$$/d' \
			     -e '/^libtool$$/d' \
			     -e '/^openvasd\/OBJ\/openvasd$$/d' \
			     -e '/^bin\/openvasd$$/d' \
			     -e '/^config\.cache$$/d' \
			     -e '/^config\.log$$/d' \
			     -e '/^config\.status$$/d' \
			     -e '/^include\/config\.h$$/d' \
		| sort | diff -cb - MANIFEST
