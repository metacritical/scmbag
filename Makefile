
# SCMBag Makefile

print=%: ; @echo $*=$($*)
CSC=csc

grab: scmbag.scm
	$(CSC) $< 
