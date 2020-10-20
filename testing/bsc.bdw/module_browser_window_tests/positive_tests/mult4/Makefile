LABNAME = Multiplier Lab Four
SHORTNAME = Mult4

BSC?=bsc

## Multiple Verilog simulator support.
VERILOGLIBS = -y $(BLUESPECDIR)/Verilog -y . 
VERIMAIN = $(BLUESPECDIR)/Verilog/main.v 

## Default simulator is iverilog

## Verilog compile command line ending is file to generate
VCOMP    = iverilog $(VERILOGLIBS) $(VERIMAIN) -o 
## Verilog compile command line to specific model called by main
VCOMPTop = -DTOP=
## Prefix to run result of Verilog comiple
VSCR     = ./

ifdef vcsi
    VCOMP    = vcsi  +v2k +libext+.v $(VERILOGLIBS) $(VERIMAIN) -o 
    VCOMPTop = +define+TOP=
endif

ifdef vcs
    VCOMP    = vcs  +v2k +libext+.v $(VERILOGLIBS) $(VERIMAIN) -o 
    VCOMPTop = +define+TOP=
endif

ifdef ncverilog
    VCOMP = ncverilog -c  +access+r  +libext+.v $(VERILOGLIBS) $(VERIMAIN) +name+
    VCOMPTop = +define+TOP=
    VSCR   = ncverilog -R +name+
endif

ifdef ncsim
    VCOMP = ncsim -c  +access+r  +libext+.v $(VERILOGLIBS) $(VERIMAIN) +name+
    VCOMPTop = +define+TOP=
    VSCR   = ncsim -R +name+
endif

ifdef cver
     VCOMP = cvsr +libext+.v  $(VERILOGLIBS) -o 
     VCOMPTop = +define+TOP=
endif


.PHONY: help
help:
	@echo "Bluespec $(LABNAME)"
	@echo "Useful targets:"
	@echo "  mk$(SHORTNAME)_v    --  build $(SHORTNAME) Verilog simulator"
	@echo "   default is iverilog, use vcs=1, vcsi=1, ncverilog=1 or cver=1"
	@echo "   to specific alternate simulator."
	@echo "  mk$(SHORTNAME).v    --  build $(SHORTNAME) Verilog "
	@echo "  mk$(SHORTNAME).vcd  --  generate VCD file (from Bluesim)"
	@echo "  mk$(SHORTNAME)_c    --  build $(SHORTNAME) Bluesim"
	@echo "  clean         --  remove intermediate files"
	@echo "  help          --  display this message"

# compile and link with Bluesim
mk%_c: %Tb.bsv
	$(BSC) -u -sim $<
	$(BSC) -o $@ -e mk$*Tb mkMult2.o mk$*Tb.o mkMult1.o

# compile to Verilog
mk%.v: %.bsv
	$(BSC) -u -verilog -keep-fires -cross-info $<


# compile and elaborate with Verilog simulator 
mk%_v: mk%.v mk%Tb.v 
	$(VCOMP)$@ $(VCOMPTop)mk$*Tb 

# produce a VCD file from Verilog simulator
mk%.vcd: mk%_v
	$(VSCR)$< +bscvcd

.PRECIOUS: mk%.v mk%_v 

.PHONY: clean
clean:
	@rm -f *.bi *.bo mk*.c mk*.h mk*.o mk*.v *_c *_v *.vcd *~ *.fsdb *.log *.info
	@rm -rf csrc INCA_libs simv.daidir .blueview

blueview: mk$(SHORTNAME)_v
	./mk$(SHORTNAME)_v +bscvcd
	mv dump.vcd mk$(SHORTNAME)Tb.vcd
	blueview mk$(SHORTNAME)Tb.info mk$(SHORTNAME)Tb.vcd

