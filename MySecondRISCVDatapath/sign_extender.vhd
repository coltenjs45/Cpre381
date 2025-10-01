library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity sign_extender is
    generic (
	IN_WIDTH  : natural := 16;
	OUT_WIDTH : natural := 32);

    port (
        input     : in std_logic_vector(IN_WIDTH-1 downto 0);
        output    : out std_logic_vector(OUT_WIDTH-1 downto 0));

end sign_extender;

architecture Behavioral of sign_extender is
begin

    output <= std_logic_vector(resize(signed(input), OUT_WIDTH));

end architecture Behavioral;