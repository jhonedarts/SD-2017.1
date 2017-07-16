library verilog;
use verilog.vl_types.all;
entity MEM_WB is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        controlIn       : in     vl_logic_vector(0 to 2);
        pcIn            : in     vl_logic_vector(31 downto 0);
        memDataIn       : in     vl_logic_vector(31 downto 0);
        aluResultIn     : in     vl_logic_vector(31 downto 0);
        destRegIn       : in     vl_logic_vector(4 downto 0);
        controlOut      : out    vl_logic_vector(0 to 2);
        pcOut           : out    vl_logic_vector(31 downto 0);
        memDataOut      : out    vl_logic_vector(31 downto 0);
        aluResultOut    : out    vl_logic_vector(31 downto 0);
        destRegOut      : out    vl_logic_vector(4 downto 0)
    );
end MEM_WB;
