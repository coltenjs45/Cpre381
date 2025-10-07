library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity pcFetch is

  generic(WIDTH : integer := 32);
 
  port(
    clock               : in std_logic;
    reset               : in std_logic;
    immediate           : in std_logic_vector(WIDTH-1 downto 0);
    register_plusImm    : in std_logic_vector(WIDTH-1 downto 0);
    muxCtrl             : in std_logic_vector(1 downto 0);
    nextInstruction     : out std_logic_vector(WIDTH-1 downto 0);
    programCounter      : out std_logic_vector(WIDTH-1 downto 0));

end pcFetch;

architecture structure of pcFetch is

  component mux4x32t1
    port(
        sel             : in std_logic_vector(1 downto 0);
        bus_in		    : in t_bus_4x32;
        o_output 		: out std_logic_vector(31 downto 0));
  end component;

  component nBit_Adder
    port(
        in_C   		    : in std_logic;
        i_A 		    : in std_logic_vector(WIDTH-1 downto 0);
        i_B 		    : in std_logic_vector(WIDTH-1 downto 0);
        o_SUM 		    : out std_logic_vector(WIDTH-1 downto 0);
        out_C	        : out std_logic);
    end component;

  component nBit_Reg
    port(
        CLK 		    : in std_logic;
        RST 	    	: in std_logic;
	    wEnable		    : in std_logic;
	    inData		    : in std_logic_vector(WIDTH-1 downto 0);
	    outData		    : out std_logic_vector(WIDTH-1 downto 0));
    end component;

    --SIGNALS--
    signal muxInput : t_bus_4x32;
    signal nextPC, add4Out, addImmOut, pcOut : std_logic_vector(WIDTH-1 downto 0);
    signal ground : std_logic;

begin
    programCounter  <= pcOut;

    muxInput(0) <= add4Out;
    muxInput(1) <= addImmOut;
    muxInput(2) <= addImmOut;
    muxInput(3) <= register_plusImm; 
    
    nextInstruction <= add4Out;

    PC: nBit_Reg port map(
        CLK     => clock,
        RST     => reset,
        wEnable => '1',
        inData  => nextPC,
        outData => pcOut);

	MUX: mux4x32t1 port map(
	    sel     => muxCtrl,
        bus_in	=> muxInput,
       o_output => nextPC);

    Add4: nBit_Adder port map(
        in_C   	=> '0',
        i_A 	=> pcOut,
        i_B 	=> x"00000004",
        o_SUM 	=> add4Out,
        out_C	=> ground);

    AddImm: nBit_Adder port map(
        in_C   	=> '0',
        i_A 	=> pcOut,
        i_B 	=> immediate,
        o_SUM 	=> addImmOut,
        out_C	=> ground);


end structure;