
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity OnesComp is

  generic(WIDTH : integer := 32);
 
  port(INPUT 		: in std_logic_vector(WIDTH-1 downto 0);
       OUTPUT 		: out std_logic_vector(WIDTH-1 downto 0));

end OnesComp;

architecture structure of OnesComp is
  
  component invg
    port(i_A              : in std_logic;
         o_F              : out std_logic);
  end component;

begin

    nBit_OnesComp: for i in 0 to WIDTH-1 generate
       INVN: invg port map(
		i_A    => INPUT(i),
		o_F    => OUTPUT(i));

    end generate nBit_OnesComp;
    

end structure;