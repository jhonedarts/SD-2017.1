library verilog;
use verilog.vl_types.all;
entity unitControl is
    port(
        opcode          : in     vl_logic_vector(5 downto 0);
        func            : in     vl_logic_vector(5 downto 0);
        controlOut      : out    vl_logic_vector(7 downto 0);
        branchSrc       : out    vl_logic_vector(1 downto 0);
        compareCode     : out    vl_logic_vector(1 downto 0)
    );
end unitControl;
