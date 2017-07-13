library verilog;
use verilog.vl_types.all;
entity compare is
    port(
        rs              : in     vl_logic_vector(31 downto 0);
        rt              : in     vl_logic_vector(31 downto 0);
        code            : in     vl_logic_vector(1 downto 0);
        isBranch        : out    vl_logic
    );
end compare;
