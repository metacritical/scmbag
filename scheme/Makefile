# SCMBag Makefile

print=%: ; @echo $*=$($*)
CSC=csc
REPL=rlwrap csi

grab: compile install

compile: scmbag.scm
	@echo "Compiling scmbag"
	$(CSC) $< 
	@scmbag -i

install:
	@echo "Installing scmbag"
	cp scmbag /usr/local/bin/

run: scmbag.scm
	$(REPL)


