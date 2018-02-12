default:
	@echo "Please have a look at the Makefile or run 'make all'."

dist:
	mkdir -p dist

results:
	mkdir -p results

tablify:
	./tablify.hs

clean:
	rm -rf dist results

all:
	# make mck-unpack mck-run # uncomment if you have `mck-Linux-1.1.0.tar` in `packages`
	make mcmas-unpack mcmas-build mcmas-run
	make mctk-binary-unpack mctk-run
	make smcdel-build smcdel-run smcdel.alt-run
	make tablify


# MCK

mck-unpack: dist
	mkdir -p dist/mck-Linux-1.1.0
	cd dist/mck-Linux-1.1.0 && tar xf ../../packages/mck-Linux-1.1.0.tar
	cd dist/mck-Linux-1.1.0 && ln -s /usr/lib/i386-linux-gnu/libffi.so.6.0.4 ./libffi.so.5

LD_LIBRARY_PATH := ./dist/mck-Linux-1.1.0/
export LD_LIBRARY_PATH

MCK = ./dist/mck-Linux-1.1.0/mck -rs

MCKNUMBERS = 3 4 5

mck-run: results
	$(foreach var, $(MCKNUMBERS), /usr/bin/time -o results/mck-$(var) -f%e $(MCK) ./mck-examples/dc$(var).mck;)


# MCMAS

mcmas-unpack: dist
	cd dist && tar xf ../packages/mcmas-1.3.0.tar.gz

mcmas-build:
	cd dist/mcmas-1.3.0 && make

NUMBERS = 3 4 5 10 15 20 30 40 50 60 70 80

MCMAS = dist/mcmas-1.3.0/mcmas

mcmas-run: results
	$(foreach var,$(NUMBERS), /usr/bin/time -o results/mcmas-$(var) -f%e $(MCMAS) mcmas-examples/dc$(var).ispl;)


# MCTK

mctk-binary-unpack: dist
	cd dist/ && unzip ../packages/MCTK-1.0.2-compiled.zip

MCTK = dist/MCTK-1.0.2/nusmv/NuSMV -dynamic

mctk-run: results
	$(foreach var,$(NUMBERS), cd dist/MCTK-1.0.2/nusmv/examples/knowledge/dc \
		&& ./dc_gencode dc_templet.smv $(var) \
		&& cd - \
		&& /usr/bin/time -o results/mctk-$(var) -f%e $(MCTK) dist/MCTK-1.0.2/nusmv/examples/knowledge/dc/test.smv;)


# SMCDEL

smcdel-build:
	cd smcdel-inputs && stack build

smcdel = $(shell cd smcdel-inputs && stack exec which smcdel)

smcdel-diningcrypto = $(shell cd smcdel-inputs && stack exec which smcdel-diningcrypto)

smcdel-run: smcdel-build results
	$(foreach var,$(NUMBERS), /usr/bin/time -o results/smcdel-$(var) -f%e $(smcdel-diningcrypto) $(var);)

SMCDELALTNUMBERS = 3 4 5 10 15

smcdel.alt-run: smcdel-build results
	$(foreach var,$(SMCDELALTNUMBERS), /usr/bin/time -o results/smcdel.alt-$(var) -f%e $(smcdel-diningcrypto) $(var) --separate;)

smcdel.txt-run: smcdel-build results
	/usr/bin/time -o results/smcdel.txt-3 -f%e $(smcdel) smcdel-inputs/dc3.smcdel.txt
	/usr/bin/time -o results/smcdel.txt-4 -f%e $(smcdel) smcdel-inputs/dc4.smcdel.txt
