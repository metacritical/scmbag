
# SCMBag Makefile

print=%: ; @echo $*=$($*)
CSC=csc
REPL=rlwrap csi

grab: scmbag.scm
	$(CSC) $< 
	cp scmbag $(OH_MY_BASH)/bin

run: scmbag.scm
	$(REPL)


