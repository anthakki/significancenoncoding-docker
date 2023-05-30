
CURL = curl
JAR = jar
JAVAC = javac

base_url = https://zenodo.org/record/5913867
goog_url = https://storage.googleapis.com/noncoding_analysishg19

app = SignificanceNoncoding

downloads = share/$(app)/AnnotationFilesComplete.zip \
	share/$(app)/UserManual.pdf \
	src.zip
subdirs = bin lib share

all: download $(subdirs) chmod

distclean: clean
	rm -f $(downloads)

clean:
	rm -f lib/$(app)/*
	rm -r share/$(app)/*
	rm -f src/$(app)/*
	@rmdir -p lib/$(app) share/$(app) src/$(app) 2>/dev/null || true

download: $(downloads)

chmod:
	chmod -R go=u-w $(subdirs)

bin: bin/$(app)
	@touch $@

lib/$(app): src
	@mkdir -p $@
	cp -f src/$(app)/*.jar $@/
	@touch $@

lib: lib/$(app)
	@touch $@

share/$(app)/AnnotationFilesComplete.zip:
	@mkdir -p $(@D)
	$(CURL) -L -o $@ $(goog_url)/$(@F)
 
share/$(app)/MutationTestFiles.zip:
	@mkdir -p $(@D)
	$(CURL) -L -o $@ $(goog_url)/$(@F)

share/$(app)/UserManual.pdf:
	@mkdir -p $(@D)
	$(CURL) -L -o $@ $(base_url)/files/$(@F)?download=1

share/$(app): share/$(app)/AnnotationFilesComplete.zip share/$(app)/UserManual.pdf
	@touch $@

share: share/$(app)
	@touch $@

src.zip:
	@mkdir -p $(@D)
	$(CURL) -L -o $@ $(base_url)/files/$(@F)?download=1

src/$(app): src.zip
	@mkdir -p $@
	( cd $@/ && \
		$(JAR) -xf /dev/stdin src/ && \
		mv -f src/* . && \
		rmdir src/ ) < $<
	for patch in p*.patch; do \
		( cd $@/ && \
			patch -p1 ) < "$$patch"; \
	done
	( cd $@/ && \
		$(JAVAC) -cp "$$( ls *.jar | tr '\n' ':' )" *.java && \
		( echo 'Main-Class: $(app)' && \
			echo "Class-Path: $$( ls *.jar | tr '\n' ' ')" ) | \
		$(JAR) -cfm $(app).jar /dev/stdin *.class && \
		rm -f *.class )
	@touch $@

src: src/$(app)
	@touch $@

.PHONY: all distclean clean download chmod
.SUFFIXES:
