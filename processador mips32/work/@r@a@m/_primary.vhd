library verilog;
use verilog.vl_types.all;
entity RAM is
    generic(
        SIZE            : integer := 16384;
        FILE_IN         : string  := "/caminho/"
    );
    port(
        Clock           : in     vl_logic;
        Address         : in     vl_logic_vector(13 downto 0);
        MemWrite        : in     vl_logic;
        MemRead         : in     vl_logic;
        WriteData       : in     vl_logic_vector(31 downto 0);
        ReadData        : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of FILE_IN : constant is 1;
end RAM;
