library verilog;
use verilog.vl_types.all;
entity EX_MEM is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        controlIn       : in     vl_logic_vector(0 to 4);
        pcIn            : in     vl_logic_vector(31 downto 0);
        aluResultIn     : in     vl_logic_vector(31 downto 0);
        rtValueIn       : in     vl_logic_vector(31 downto 0);
        destRegIn       : in     vl_logic_vector(4 downto 0);
        controlOut      : out    vl_logic_vector(0 to 4);
        pcOut           : out    vl_logic_vector(31 downto 0);
        aluResultOut    : out    vl_logic_vector(31 downto 0);
        rtValueOut      : out    vl_logic_vector(31 downto 0);
        destRegOut      : out    vl_logic_vector(4 downto 0)
    );
end EX_MEM;
