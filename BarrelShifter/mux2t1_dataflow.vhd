-------------------------------------------------------------------------
-- Graeme Anderson
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Mux.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 multiplexer.
--
--
-- NOTES:
-- 9/3/25 by Graeme: Design created
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2t1_dataflow is

  port(SEL    : in std_logic;
       iA 		: in std_logic;
       iB 		: in std_logic;
       OUTPUT : out std_logic);

end mux2t1_dataflow;

architecture dataflow of mux2t1_dataflow is

begin

  OUTPUT <= iA when (SEL = '0') else
            iB when (SEL = '1') else
	 '0';
  
end dataflow;