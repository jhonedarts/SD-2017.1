library verilog;
use verilog.vl_types.all;
entity mips32TOPTest2 is
    generic(
        halfcycle       : integer := 5
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of halfcycle : constant is 1;
end mips32TOPTest2;