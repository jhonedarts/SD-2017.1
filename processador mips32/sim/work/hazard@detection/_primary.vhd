library verilog;
use verilog.vl_types.all;
entity hazardDetection is
    port(
        rs              : in     vl_logic_vector(4 downto 0);
        rt              : in     vl_logic_vector(4 downto 0);
        rtEX            : in     vl_logic_vector(4 downto 0);
        memRead         : in     vl_logic;
        isBranch        : in     vl_logic;
        pcWrite         : out    vl_logic;
        ifIdFlush       : out    vl_logic
    );
end hazardDetection;
