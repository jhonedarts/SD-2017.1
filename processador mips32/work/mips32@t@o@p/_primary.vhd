library verilog;
use verilog.vl_types.all;
entity mips32TOP is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        memWr           : out    vl_logic;
        memRd           : out    vl_logic;
        memAddr         : out    vl_logic_vector(13 downto 0);
        memDataIn       : out    vl_logic_vector(31 downto 0);
        brDataIn        : out    vl_logic_vector(31 downto 0);
        brAddr          : out    vl_logic_vector(4 downto 0);
        brWrite         : out    vl_logic
    );
end mips32TOP;
