library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        enable          : in     vl_logic;
        nextpc          : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end PC;
