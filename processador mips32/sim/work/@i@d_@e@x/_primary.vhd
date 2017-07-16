library verilog;
use verilog.vl_types.all;
entity ID_EX is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        opcodeIn        : in     vl_logic_vector(5 downto 0);
        pcIn            : in     vl_logic_vector(31 downto 0);
        controlIn       : in     vl_logic_vector(0 to 7);
        rsValueIn       : in     vl_logic_vector(31 downto 0);
        rtValueIn       : in     vl_logic_vector(31 downto 0);
        offset16In      : in     vl_logic_vector(31 downto 0);
        rsIn            : in     vl_logic_vector(4 downto 0);
        rtIn            : in     vl_logic_vector(4 downto 0);
        rdIn            : in     vl_logic_vector(4 downto 0);
        opcodeOut       : out    vl_logic_vector(5 downto 0);
        pcOut           : out    vl_logic_vector(31 downto 0);
        controlOut      : out    vl_logic_vector(0 to 7);
        rsValueOut      : out    vl_logic_vector(31 downto 0);
        rtValueOut      : out    vl_logic_vector(31 downto 0);
        offset16Out     : out    vl_logic_vector(31 downto 0);
        rsOut           : out    vl_logic_vector(4 downto 0);
        rtOut           : out    vl_logic_vector(4 downto 0);
        rdOut           : out    vl_logic_vector(4 downto 0)
    );
end ID_EX;
