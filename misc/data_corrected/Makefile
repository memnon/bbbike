#
# $Id: Makefile,v 1.21 2004/06/10 22:02:10 eserte Exp $
#

# See also comments in correct_data.pl

#   Analyse der Dateien, die korrigiert werden m�ssen #######################
#
#   Bereits Dateien im GPS-Format:
#   - misc/mps_examples: sind GPS-Daten, also bereits "korrigiert"
#   - misc/geonet: sind GPS-Daten
#   - misc/gps_data: sind GPS-Daten
#   - misc/gelbeseiten: Daten innerhalb Berlins, ausserdem mit Telbuch*.pm
#     erzeugt, also GPS-Daten
#   - miscsrc/senat_b: sind GPS- oder Vermessungsdaten
#
#   Dateien, die nicht konvertiert werden brauchen:
#   - ampelschaltung-orig und ampelschaltung-orig.txt, da es sich um reine
#     Berliner Daten handelt
#   - misc/old: ist alt, kann also ignoriert werden
#   - misc/*.bbd: bis auf weblinks.bbd handelt es sich um Berliner Daten.
#     weblinks.bbd ist sowieso recht ungenau, aber trotzdem einmalig
#     eine Probekorrektur vornehmen
#   - miscsrc/condat/kinos.bbd: alt, kann ignoriert werden
#   - tmp: kann ignoriert werden, -uncorrected-Dateien k�nnten danach
#     gel�scht werden
#   - babybike/data/fragezeichen.bbd: ein symlink
#   - projects/radlstadtplan_muenchen: ignorieren
#   - projects/solarmove/data: innerhalb Berlins, muss nicht konvertiert
#     werden
#   - projects/www.radzeit.de: wird von data etc. kopiert
#
#   Dateien, f�r die eine Konvertierung vorhanden und getestet ist:
#
#   Dateien, f�r die eine Konvertierung vorhanden und NICHT getestet ist:
#   - data/*-orig (make rule conv-orig)
#   - misc/temp_blockings: m�ssen konvertiert werden (einige Brandenburger
#     Dateien sind n�mlich dabei) (make rule conv-temp-blockings)
#   - .bbr-Dateien (in meinem ~/.bbbike/route-Verzeichnis) auch
#     konvertieren, correct_data.pl hat jetzt .bbr support mit -bbr
#     (make rule conv-bbr)
#
#   Dateien, die noch behandelt werden m�ssen:
#     keine mehr!
#
# - Schritte zur Konvertierung:
#   - Checkin aller Dateien in data/*, misc/temp_blockings/*, misc/(bbd),
#     ~/.bbbike/route/**
#   - Ausf�hren
#     make realclean
#XXX clean bbr/**?
#     make init
#     make conv-orig
#     make conv-temp-blockings
#     make conv-bbr
#      XXX missing XXX
#     make diff
#
#   - alle konvertierten Dateien m�ssen h�ndisch mit diff kontrolliert werden!
#
#   - Dateien in ~/.bbbike/route/... => RCS. OK, gemacht!
#   - data/*-orig => data/old, data_corrected/*-orig => data
#   - make in data
#   - make test in bbbike
#   - misc/temp_blockings => data/old, RCS-Dateien retten
#   - alle Programmreferenzen und MANIFESTe und CVS checkins f�r
#     temp_blockings �ndern
#   - make test mit temp_blockings-Tests
#   - ci -r4 oder so �hnlich durchf�hren

# .if !exists(Makefile.inc)
# .error Please execute "touch -t 197001010000 Makefile.inc"
# .else
# .include "Makefile.inc"
# .endif

MISCDIR=		../misc
MISCSRCDIR=		../miscsrc

DATADIR=		../data
CONV=			${MISCSRCDIR}/correct_data.pl
TARGETS!=		${MAKE} -f ../data/Makefile -V TARGETS
TARGETS+=		inaccessible_strassen
CONVDB=			conv.db
CONVDB_MODTIME=		.conv.db.modtime
CONVLINE2=		${CONV} -minpoints=5 -refdist 10000,20000,40000,80000,120000 -convdata ${CONVDB} -inberlincheck -keepeverything
CONVLINE_BBR=		${CONVLINE2} -bbr

all:	conv

######################################################################

# XXX ampelschaltung-orig ausschliessen
conv-orig:
	for i in ../data/*-orig; do \
	    if [ "`basename $$i`" != "ampelschaltung-orig" ] ; \
		then \
	        echo "$$i -> `basename $$i`"; \
	        ${CONVLINE2} $$i > `basename $$i`; \
	    fi \
	done
	@echo "ampelschaltung-orig"
	cp -f ../data/ampelschaltung-orig ampelschaltung-orig
	@echo "fragezeichen-orig"
	${CONVLINE2} ../misc/fragezeichen-orig > fragezeichen-orig
	@echo "ampelschaltung-orig.txt"
	cp -f ../misc/ampelschaltung-orig.txt ampelschaltung-orig.txt

conv-temp-blockings:
	-mkdir temp_blockings
	for i in ../misc/temp_blockings/*.bbd; do \
	    echo "$$i -> temp_blockings/`basename $$i`"; \
	    ${CONVLINE2} $$i > temp_blockings/`basename $$i`; \
	done

conv-bbr:
	-mkdir -p bbr/tmp bbr/touren bbr/vorschlaege bbr/wanderungen
	for i in $(HOME)/.bbbike/route/*.bbr; do \
	    target=bbr/`basename $$i`; \
	    if [ ! -e $$target ] ; then \
	        echo "$$i -> $$target"; \
	        ${CONVLINE_BBR} $$i > $$target; \
	    fi \
	done
	for dir in $(HOME)/.bbbike/route/*; do \
	    if [ -d $$dir -a $$dir != "$(HOME)/.bbbike/route/RCS" ] ; then \
	        echo "Directory $$dir"; \
		for i in $$dir/*.bbr; do \
		    target=bbr/`basename $$dir`/`basename $$i`; \
		    if [ ! -e $$target ] ; then \
			echo "$$i -> $$target"; \
			${CONVLINE_BBR} $$i > $$target; \
		    fi \
		done; \
	    fi \
	done

diff:
	for i in *-orig; do \
	    diff -u $$i ../data/$$i | more; \
	done

######################################################################

conv:	build-orig \
	${TARGETS} fragezeichen Berlin.coords.data Potsdam.coords.data \
	permissions

build-orig:
	cd ${DATADIR} && ${MAKE}

ampelschaltung:	${DATADIR}/ampelschaltung
	cp -fp ${DATADIR}/ampelschaltung .

# Should handle any conversions correctly, but there aren't any anymore...
radwege:	radwege_exact
	${MISCSRCDIR}/convert_radwege < radwege_exact > radwege

.for target in $(TARGETS:Nampelschaltung:Nradwege)
${target}:	${DATADIR}/${target}
	${CONV} -minpoints=5 -refdist 10000,20000,40000,80000,120000 -convdata ${CONVDB} -verboseoutput $> > $@~ && mv -f $@~ $@
.endfor

# XXX don't duplicate cmdline
fragezeichen:	${MISCDIR}/fragezeichen
	${CONV} -minpoints=5 -refdist 10000,20000,40000,80000,120000 -convdata ${CONVDB} -verboseoutput $> > $@~ && mv -f $@~ $@

Berlin.coords.data:	${DATADIR}/Berlin.coords.data
	cp -pf $> $@

# XXX hmmm... this should really be converted
Potsdam.coords.data:	${DATADIR}/Potsdam.coords.data
	cp -pf $> $@

permissions:
	chmod ugo+r *

clean:
	rm -rf $(TARGETS)

# Building ${CONVDB} is expensive ... try to save it first
realclean:	clean
	-mv -f ${CONVDB} /tmp
	rm -rf ${CONVDB} ${CONVDB_MODTIME}

init:	init-ident init-ostsee

# Iterate over all files mentioned in BASE and convert the B$x,$y
# notation, if necessary. This should be the first step if starting
# the conversion from an empty directory. This should also be called
# every time new points were added in the ${DATADIR} files!!!
#
# If something went wrong it's probably best to:
#    make realclean init all
#
# The second line assumes that all radwege are in Berlin. If this is not
# the case, I have to switch to something like PostGIS & truly_inside
# the Berlin borders or such.

# These coordinates form a rectangle contained completely in Berlin. This is
# used to minimize the number of point_in_polygon calls.
INNER_BERLIN_COORDS=-5400 19500 20800 1950

init-ident:	/tmp/berlin_polygon.bbd pre-init-ident do-init-ident

/tmp/berlin_polygon.bbd: ${DATADIR}/berlin
	${MISCSRCDIR}/combine_streets.pl -closedpolygon $> > $@

pre-init-ident:
	touch ${CONVDB_MODTIME}

do-init-ident:
	cd ${DATADIR} && perl -w -I.. -I../lib -MKarte -MStrassen -MObject::Iterate=iterate -MList::Util=max,min -MDB_File -MVectorUtil=point_in_grid,point_in_polygon -e '\
Karte::preload(":all");\
$$berlin = Strassen->new("/tmp/berlin_polygon.bbd");\
@polygon = map { [ split /,/, $$_ ] } @{ $$berlin->get(0)->[Strassen::COORDS] };\
$$minx = min map { $$_->[0] } @polygon;\
$$miny = min map { $$_->[1] } @polygon;\
$$maxx = max map { $$_->[0] } @polygon;\
$$maxy = max map { $$_->[1] } @polygon;\
$$convdb = "${.CURDIR}/${CONVDB}";\
$$touch_needed = ! -e $$convdb;\
tie %db, "DB_File", $$convdb, O_RDWR|O_CREAT, 0600 or die "Cannot tie $$convdb: $$!";\
if ($$touch_needed) { utime 0, 0, $$convdb }\
$$modtime = (stat($$convdb))[9];\
utime $$modtime, $$modtime, "${.CURDIR}/${CONVDB_MODTIME}";\
open(B, "BASE") or die "Cannot open BASE: $$!";\
@base = <B>;\
close B;\
for (@base) {\
 ($$file,$$type) = split /\s+/;\
 next if $$file =~ /^(ampelschaltung-orig|label-orig|relation_gps-orig)$$/;\
 next if -M $$file >= -M "${.CURDIR}/${CONVDB_MODTIME}";\
 warn "$$file...\n";\
 $$s=Strassen->new($$file);\
 iterate {\
  for my $$c (@{ $$_->[Strassen::COORDS] }) {\
   $$c =~ s/^:.*://;\
   next if $$c !~ /^[-+]?\d+,[-+]?\d+$$/;\
   next if exists $$db{$$c};\
   my($$px,$$py) = split /,/, $$c;\
   if    ($$file eq "plz-orig") { }\
   elsif (point_in_grid($$px,$$py,qw(${INNER_BERLIN_COORDS}))) { }\
   elsif (!point_in_grid($$px,$$py,$$minx,$$miny,$$maxx,$$maxy)) { next }\
   elsif (point_in_polygon([$$px,$$py],\@polygon)) { }\
   else  { next }\
   $$db{$$c} = $$c\
  }\
 } $$s;\
}'

#	cd ${DATADIR} && perl -I.. -I../lib -MStrassen -MObject::Iterate=iterate -MDB_File -e '\
#exit(0) if -M "radwege" >= -M "${.CURDIR}/${CONVDB_MODTIME}";\
#warn "radwege...\n";\
#tie %db, "DB_File", "${.CURDIR}/${CONVDB}", O_RDWR|O_CREAT, 0600 or die;\
#$$s=Strassen->new("radwege");\
#iterate {\
# for my $$c (@{ $$_->[Strassen::COORDS] }) { $$db{$$c} = $$c }\
#} $$s'

# Special handling for Ostsee (see comments in wasserumland2-orig).
# This should be the second step if starting the conversion from an
# empty directory.
init-ostsee:
	perl -w -MDB_File -e 'tie %db, "DB_File", "${CONVDB}", O_RDWR, 0600 or die; $$db{$$_} = $$_ for (qw(6556,269275 129023,269530 -212543,268820 6556,269275))'

link-check-files:
	for i in BASE add_str multi_bez_str str_cont_ausnahme add_plaetze sehenswuerdigkeit_img; do \
	    echo "Check $$i"; \
	    [ ! -e $$i ] && ln -s ../data/$$i || true ; \
	done

.include "${DATADIR}/Makefile.mapfiles"
