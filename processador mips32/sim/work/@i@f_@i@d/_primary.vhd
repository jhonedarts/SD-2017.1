library verilog;
use verilog.vl_types.all;
entity IF_ID is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        flush           : in     vl_logic;
        pcIn            : in     vl_logic_vector(31 downto 0);
        instIn          : in     vl_logic_vector(31 downto 0);
        pcOut           : out    vl_logic_vector(31 downto 0);
        instOut         : out    vl_logic_vector(31 downto 0)
    );
end IF_ID;
