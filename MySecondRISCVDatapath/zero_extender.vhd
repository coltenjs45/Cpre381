library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity zero_extender is
    generic (
	IN_WIDTH  : natural := 16;
	OUT_WIDTH : natural := 32);

    port (
        input     : in std_logic_vector(IN_WIDTH-1 downto 0);
        output    : out std_logic_vector(OUT_WIDTH-1 downto 0));

end zero_extender;

architecture Behavioral of zero_extender is
begin

    output <= (OUT_WIDTH-1 downto IN_WIDTH => '0') & input;

end architecture Behavioral;