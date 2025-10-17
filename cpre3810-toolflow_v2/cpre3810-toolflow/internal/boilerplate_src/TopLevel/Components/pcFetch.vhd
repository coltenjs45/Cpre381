library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity pcFetch is

  generic(WIDTH : integer := 32);
 
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    conditionBJ         : in std_logic;
    jump                : in std_logic;
    jumpWithRegister    : in std_logic;
    immediate           : in std_logic_vector(WIDTH-1 downto 0);
    register_plusImm    : in std_logic_vector(WIDTH-1 downto 0);
    nextInstruction     : out std_logic_vector(WIDTH-1 downto 0);
    programCounter      : out std_logic_vector(WIDTH-1 downto 0));

end pcFetch;

architecture structure of pcFetch is

  component mux2t1_N
    port(
      i_S              : in std_logic;
      i_D0             : in std_logic_vector(WIDTH-1 downto 0);
      i_D1             : in std_logic_vector(WIDTH-1 downto 0);
      o_O              : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component nBit_Adder
    port(
      in_C   		      : in std_logic;
      i_A 		        : in std_logic_vector(WIDTH-1 downto 0);
      i_B 		        : in std_logic_vector(WIDTH-1 downto 0);
      o_SUM 		      : out std_logic_vector(WIDTH-1 downto 0);
      out_C	          : out std_logic);
    end component;

  component nBit_Reg
    port(
      CLK 		        : in std_logic;
      RST 	    	    : in std_logic;
	    wEnable		      : in std_logic;
	    inData		      : in std_logic_vector(WIDTH-1 downto 0);
	    outData		      : out std_logic_vector(WIDTH-1 downto 0));
    end component;

    --SIGNALS--
    signal nextPC, add4Out, addImmOut, pcOut, jumpAddress, pcJALR : std_logic_vector(WIDTH-1 downto 0);
    signal ground : std_logic;

begin
    programCounter  <= pcOut;
    
    nextInstruction <= add4Out;

    PC: nBit_Reg port map(
      CLK     => clock,
      RST     => reset,
      wEnable => '1',
      inData  => nextPC,
      outData => pcOut);

	  MUX_JUMP: mux2t1_N port map(
	    i_S     => jump,
      i_D0    => immediate,
      i_D1    => register_plusImm,
      o_O     => jumpAddress);

    MUX_IMM: mux2t1_N port map(
	    i_S     => conditionBJ,
      i_D0    => add4Out,
      i_D1    => addImmOut,
      o_O     => nextPC);

    MUX_PC: mux2t1_N port map(
	    i_S     => jumpWithRegister,
      i_D0    => pcOut,
      i_D1    => x"00000000",
      o_O     => pcJALR);

    Add4: nBit_Adder port map(
      in_C   	=> '0',
      i_A 	  => pcOut,
      i_B 	  => x"00000004",
      o_SUM 	=> add4Out,
      out_C	  => ground);

    AddImm: nBit_Adder port map(
      in_C    => '0',
      i_A 	  => pcJALR,
      i_B 	  => jumpAddress,
      o_SUM 	=> addImmOut,
      out_C	  => ground);


end structure;