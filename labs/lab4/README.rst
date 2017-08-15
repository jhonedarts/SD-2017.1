========================================
 Altera ModelSim Makefile Instructions
========================================

This can be used to run your modelsim projects on the commandline,
i.e. without the GUI.

Directory Layout
~~~~~~~~~~~~~~~~~

As ModelSim will throw a lot of garbage into its project dir,
a directory layout as follows was picked:
  
  sim/

  sim/fun

  sim/syn

  sim/tb

  sim/tests

  src/

  syn/src

Your HDL code goes into *src/*.
Your test benches goes into *sim/tb*.
The test directory contains all test vectors and modelsim .do files.
Funcional simulation directives goes into *sim/fun*
Gate level simulation directives goes into *sim/syn*
Your gate level netlist goes into *syn/src*

Usage
~~~~~~

In order to use this to build your project, drop all your HDL code into fpga.
Edit *sim/fun/Makefile* or *sim/syn/Makefile* to suit your needs, most interesting variables there
should be:

* SRCDIR (your HDL code)
* TBDIR (your test bench code)

Now you can compile your code by::

  user$: make -C sim compile
 
In order run your tests::

  user$: make -C sim

