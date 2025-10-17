
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nBit_Reg is

  generic(WIDTH : integer := 32);
 
  port( CLK 		: in std_logic;
        RST 		: in std_logic;
	wEnable		: in std_logic;
	inData		: in std_logic_vector(WIDTH-1 downto 0);
	outData		: out std_logic_vector(WIDTH-1 downto 0));

end nBit_Reg;

architecture structure of nBit_Reg is
  
  component dffg
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
  end component;

begin

    nBit_Reg: for i in 0 to WIDTH-1 generate
       DFFN: dffg port map(
		i_CLK    => CLK,
		i_RST    => RST,
		i_WE	 => wEnable,
		i_D	 => inData(i), 
		o_Q	 => outData(i));

    end generate nBit_Reg;
    

end structure;
