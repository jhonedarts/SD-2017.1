library verilog;
use verilog.vl_types.all;
entity mips32TOP2 is
    port(
        clk             : in     vl_logic;
        clkMem          : in     vl_logic;
        rst             : in     vl_logic
    );
end mips32TOP2;
