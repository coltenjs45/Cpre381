library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity BarrelShifter is
    generic(WIDTH : integer := 32);
    
    port(
        input           : in std_logic_vector(WIDTH-1 downto 0);
        shiftAmnt       : in std_logic_vector(WIDTH-1 downto 0);
        control         : in std_logic_vector(1 downto 0);
        output          : out std_logic_vector(WIDTH-1 downto 0));

end BarrelShifter;

architecture dataflow of BarrelShifter is
    signal shiftLeftUnsigned  : unsigned(WIDTH-1 downto 0);
    signal shiftRightUnsigned : unsigned(WIDTH-1 downto 0);
    signal shiftSigned      : signed(WIDTH-1 downto 0);


    begin

    shiftLeftUnsigned     <= shift_left(unsigned(input), to_integer(unsigned(shiftAmnt)));
    shiftRightUnsigned    <= shift_right(unsigned(input), to_integer(unsigned(shiftAmnt)));
    shiftSigned           <= shift_right(signed(input), to_integer(unsigned(shiftAmnt)));

    output <= std_logic_vector(shiftLeftUnsigned) when (control = "00") else
              std_logic_vector(shiftRightUnsigned) when (control = "10") else
              std_logic_vector(shiftSigned) when (control = "11") else
              input;
end dataflow;