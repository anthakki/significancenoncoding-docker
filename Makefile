
CURL = curl
JAR = jar
JAVAC = javac

base_url = https://zenodo.org/record/5913867
goog_url = https://storage.googleapis.com/noncoding_analysishg19

app = SignificanceNoncoding
subdirs := $(shell cat .dockerignore | sed -nE 's@^!([^/]*)(.*)$$@\1@p')

all: download $(subdirs) chmod

distclean: clean
	rm -f share/$(app)/AnnotationFilesComplete.zip share/$(app)/MutationTestFiles.zip share/$(app)/UserManual.pdf
	@rmdir -p share/$(app) 2>/dev/null || true

clean:
	rm -f lib/$(app)/*
	$(MAKE) -C src/$(app)/ clean
	@rmdir -p lib/$(app) share/$(app) 2>/dev/null || true

download: share/$(app)/AnnotationFilesComplete.zip share/$(app)/UserManual.pdf

chmod:
	chmod -R go=u-w $(subdirs)

bin/$(app): src/$(app)/$(app)
	@mkdir -p $(@D)
	cp -f $< $@

bin: bin/$(app)
	@touch $@

lib/$(app): src/$(app)/$(app).jar
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

src/$(app)/$(app).jar:
	$(MAKE) -C src/$(app)/ all cleanobj

src/$(app): src/$(app)/$(app).jar
	@touch $@

src: src/$(app)
	@touch $@

.PHONY: all distclean clean download chmod
.SUFFIXES:
