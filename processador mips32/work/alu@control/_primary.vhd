library verilog;
use verilog.vl_types.all;
entity aluControl is
    port(
        opcode          : in     vl_logic_vector(5 downto 0);
        funct           : in     vl_logic_vector(5 downto 0);
        aluOp           : out    vl_logic_vector(3 downto 0)
    );
end aluControl;
