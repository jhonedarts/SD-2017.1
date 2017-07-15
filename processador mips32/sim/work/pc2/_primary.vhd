library verilog;
use verilog.vl_types.all;
entity pc2 is
    port(
        enable          : in     vl_logic;
        nextpc          : in     vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end pc2;
