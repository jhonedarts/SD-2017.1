library verilog;
use verilog.vl_types.all;
entity ROM is
    generic(
        SIZE            : integer := 1024;
        FILE_IN         : string  := "instructions.input"
    );
    port(
        Clock           : in     vl_logic;
        Address         : in     vl_logic_vector(9 downto 0);
        ReadData        : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of FILE_IN : constant is 1;
end ROM;
