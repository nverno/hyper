emacs ?= emacs
ruby ?= ruby
wget ?= wget

dl= provision.sh

.PHONY: clean distclean
all:

html:
	./$(dl)

clean:
	$(RM) *~

distclean: clean
	$(RM) *.json
