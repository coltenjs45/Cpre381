
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nBit_Adder is

  generic(WIDTH : integer := 32);
 
  port(in_C   		: in std_logic;
       i_A 		    : in std_logic_vector(WIDTH-1 downto 0);
       i_B 		    : in std_logic_vector(WIDTH-1 downto 0);
       o_SUM 		  : out std_logic_vector(WIDTH-1 downto 0);
       out_C	    : out std_logic);

end nBit_Adder;

architecture structure of nBit_Adder is
  
  component Adder
    port(iCARRY         : in std_logic;
         iA             : in std_logic;
         iB             : in std_logic;
         oSUM           : out std_logic;
         oCARRY         : out std_logic);
  end component;

  signal s_internalCarry  : std_logic_vector(WIDTH downto 0);


begin  
    s_internalCarry(0) <= in_C;
    
    nBit_Adder: for i in 0 to WIDTH-1 generate
       ADDI: Adder port map(
		iCARRY		=> s_internalCarry(i),
		iA		=> i_A(i),
		iB		=> i_B(i),
		oSUM		=> o_SUM(i),
		oCARRY		=> s_internalCarry(i+1));

    end generate nBit_Adder;
    
    out_C <= s_internalCarry(WIDTH);    

end structure;
