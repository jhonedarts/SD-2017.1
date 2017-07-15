library verilog;
use verilog.vl_types.all;
entity mux2 is
    generic(
        width           : vl_notype
    );
    port(
        a               : in     vl_logic_vector(31 downto 0);
        b               : in     vl_logic_vector(31 downto 0);
        sel             : in     vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 5;
end mux2;
