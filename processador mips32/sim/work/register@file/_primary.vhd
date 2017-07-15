library verilog;
use verilog.vl_types.all;
entity registerFile is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rWriteValue     : in     vl_logic_vector(31 downto 0);
        rWriteAddress   : in     vl_logic_vector(4 downto 0);
        regWrite        : in     vl_logic;
        rsData          : out    vl_logic_vector(31 downto 0);
        rtData          : out    vl_logic_vector(31 downto 0)
    );
end registerFile;
