-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a behavioral 
-- signed adder operating on std_logic_vector inputs. 
--
--
-- NOTES: For simplicity, we cast to signed values before operating and cast back.
-- This design does not handle overflow.


-- 8/19/09 by JAZ::Design created.
-- 1/16/25 by CWS::Switched from integer to std_logic_vector and numeric_std.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is

  port(iCARRY           : in std_logic;
       iA               : in std_logic;
       iB               : in std_logic;
       oSUM             : out std_logic;
       oCARRY           : out std_logic);

end Adder;

architecture structure of Adder is
  
  component xorg2
    port(i_A              : in std_logic;
         i_B		  : in std_logic;
         o_F              : out std_logic);
  end component;

  component org2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component andg2
    port(i_A            : in std_logic;
         i_B            : in std_logic;
         o_F            : out std_logic);
  end component;


  signal s_xor1		: std_logic;
  signal s_and1         : std_logic;
  signal s_and2         : std_logic;

begin

  g_xor1: xorg2
    port MAP(i_A	       => iA,
             i_B               => iB,
             o_F               => s_xor1);
  
  g_xorSUM: xorg2
    port MAP(i_A	       => s_xor1,
             i_B               => iCARRY,
             o_F               => oSUM);


  g_and1: andg2
    port MAP(i_A               => s_xor1,
             i_B               => iCARRY,
             o_F               => s_and1);

  g_and2: andg2
    port MAP(i_A               => iA,
             i_B               => iB,
             o_F               => s_and2);

  g_orCARRY: org2
    port MAP(i_A               => s_and1,
             i_B               => s_and2,
             o_F               => oCARRY);
  
end structure;
