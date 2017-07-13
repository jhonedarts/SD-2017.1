library verilog;
use verilog.vl_types.all;
entity forwardingUnit is
    port(
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rsID            : in     vl_logic_vector(4 downto 0);
        rtID            : in     vl_logic_vector(4 downto 0);
        destRegEX       : in     vl_logic_vector(4 downto 0);
        destRegMEM      : in     vl_logic_vector(4 downto 0);
        destRegWB       : in     vl_logic_vector(4 downto 0);
        regWriteEX      : in     vl_logic;
        regWriteMEM     : in     vl_logic;
        regWriteWB      : in     vl_logic;
        forwardRS       : out    vl_logic_vector(1 downto 0);
        forwardRT       : out    vl_logic_vector(1 downto 0);
        forwardRSID     : out    vl_logic_vector(1 downto 0);
        forwardRTID     : out    vl_logic_vector(1 downto 0)
    );
end forwardingUnit;
