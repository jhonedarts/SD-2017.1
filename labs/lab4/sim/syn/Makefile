LIBRARY_DEVICE := cycloneive
CASES := $(wildcard ../tests/*.do)
TOP_LEVEL := ALU
SDF_SOURCE := $(TOP_LEVEL)_v
NETLIST_REGION := DUT2
TESTINPUTS := $(wildcard ../tests/*.input)
TRANSCRIPT := $(patsubst ../tests/%.do,results/%.transcript,$(CASES))
DOFILES := $(patsubst ../tests/%.do,build/%.do,$(CASES))
TESTINPUTSBUILD := $(patsubst ../tests/%.input,build/%.input,$(TESTINPUTS))
SRCDIR := ../../src
TBDIR := ../../sim/tb
NETLIST_DIR := ../../syn/src
# SRCS := $(shell find $(SRCDIR) -regextype posix-egrep -regex ".*(v|$(TOP_LEVEL).vo)$")
SRCS := $(shell find $(SRCDIR) -name '*.v' -type f)
SRCS_NETLIST :=  $(shell find $(NETLIST_DIR) -name '$(TOP_LEVEL).vo' -type f)
TBS := $(shell find $(TBDIR) -name '*.v' -type f)
INC := $(shell find $(SRCDIR) -type d -exec echo -n '+incdir+../'{} \;)
TBINC := $(shell find $(TBDIR) -type d -exec echo -n '+incdir+../'{} \;)
STATUS := build/.status
all: $(TRANSCRIPT)

compile: $(STATUS)

$(STATUS): $(SRCS) | build/Makefile
	make -C build
	touch $@

build/Makefile:
	mkdir -p build
	(cd build; vlib work; vmap work work)
	(cd build; for file in $(SRCS); do \
	vlog +acc -source -nocovercells $(INC) ../$$file || exit 1; done)
	(cd build; for file in $(TBS); do \
	vlog +acc -source -nocovercells $(TBINC) ../$$file || exit 1; done)	
	(cd build; for file in $(SRCS_NETLIST); do \
	vlog +acc -source ../$$file || exit 1; done)	
	cp $(NETLIST_DIR)/$(SDF_SOURCE).sdo build
	(cd build; vmake > Makefile)

results:
	mkdir -p results

$(DOFILES) : build/%.do : ../tests/%.do
	mkdir -p build
	echo 'proc start {m} {vsim -L cycloneive_ver -sdftyp /$(NETLIST_REGION)=../../../syn/src/$(SDF_SOURCE).sdo work.$$m}' \
	| cat - $< > $@ 

$(TESTINPUTSBUILD) : build/% : ../tests/%
	cp $< $@
	
$(TRANSCRIPT) : results/%.transcript : build/%.do $(STATUS) $(TESTINPUTSBUILD) | results
	(cd build; \
	vsim < ../$< | tee ../$@)
	cp build/vsim.wlf $(patsubst %.transcript,%.wlf,$@)

clean:
	rm -rf results build

.PHONY := all clean compile
