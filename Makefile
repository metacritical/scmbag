
# SCMBag Makefile

print=%: ; @echo $*=$($*)
CSC=csc
REPL=rlwrap csi

grab: scmbag.scm
	$(CSC) $< 

run: scmbag.scm
	$(REPL)


