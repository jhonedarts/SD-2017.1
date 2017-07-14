library verilog;
use verilog.vl_types.all;
entity mips32TOP2 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        controlCode     : out    vl_logic_vector(11 downto 0);
        memAddr         : out    vl_logic_vector(13 downto 0);
        memDataIn       : out    vl_logic_vector(31 downto 0);
        brDataIn        : out    vl_logic_vector(31 downto 0);
        brAddr          : out    vl_logic_vector(4 downto 0)
    );
end mips32TOP2;
