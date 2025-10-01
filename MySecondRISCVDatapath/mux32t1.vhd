
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.my_package.all;

entity mux32t1 is
  
  port(SEL              : in std_logic_vector(4 downto 0);
       bus_in		: in t_bus_32x32;
       OUTPUT 		: out std_logic_vector(31 downto 0));

end mux32t1;

architecture dataflow of mux32t1 is

begin
    OUTPUT <= bus_in(to_integer(unsigned(SEL)));
  
end dataflow;