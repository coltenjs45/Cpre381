-- Used ChatGPT 5.0 (or whatever the free version was on 9/10/25) to generate the architecture: Lines 18 - 26

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder5t32 is

  port(	SEL		: in std_logic_vector(4 downto 0);
	enable		: in  STD_LOGIC;
	OUTPUT		: out std_logic_vector(31 downto 0));

  
end decoder5t32;

architecture Behavioral of decoder5t32 is
begin
  process(SEL, enable)
    begin
        if enable = '1' then
            OUTPUT <= (others => '0'); -- default all outputs to 0
            OUTPUT(to_integer(unsigned(SEL))) <= '1'; -- set the selected output
        else
            OUTPUT <= (others => '0'); -- outputs remain 0 when not enabled
        end if; 
  end process;
end Behavioral;
