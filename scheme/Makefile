
# SCMBag Makefile

print=%: ; @echo $*=$($*)
CSC=csc
REPL=rlwrap csi

grab: scmbag.scm
	$(CSC) $< 

install:
	cp scmbag /usr/local/bin/

run: scmbag.scm
	$(REPL)


