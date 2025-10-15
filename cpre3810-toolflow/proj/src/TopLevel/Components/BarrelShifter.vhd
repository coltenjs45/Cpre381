library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity BarrelShifter is
    generic(WIDTH : integer := DATA_WIDTH);
    
    port(
        input           : in std_logic_vector(WIDTH-1 downto 0);
        shiftAmnt       : in std_logic_vector(WIDTH-1 downto 0);
        ALUctrl         : in std_logic_vector(3 downto 0);
        output          : out std_logic_vector(WIDTH-1 downto 0));

end BarrelShifter;

architecture dataflow of BarrelShifter is
    signal shiftLeftLogical     : unsigned(WIDTH-1 downto 0);
    signal shiftRightLogical    : unsigned(WIDTH-1 downto 0);
    signal shiftRightArithmetic : signed(WIDTH-1 downto 0);
    signal ctrlSlice            : std_logic_vector(1 downto 0);

    begin
    
    ctrlSlice            <= ALUctrl(1 downto 0);
    shiftLeftLogical     <= shift_left(unsigned(input), to_integer(unsigned(shiftAmnt)));
    shiftRightLogical    <= shift_right(unsigned(input), to_integer(unsigned(shiftAmnt)));
    shiftRightArithmetic <= shift_right(signed(input), to_integer(unsigned(shiftAmnt)));

    output <= std_logic_vector(shiftLeftLogical) when (ctrlSlice = "11") else
              std_logic_vector(shiftRightLogical) when (ctrlSlice = "01") else
              std_logic_vector(shiftRightArithmetic) when (ctrlSlice = "10") else
              input;
end dataflow;