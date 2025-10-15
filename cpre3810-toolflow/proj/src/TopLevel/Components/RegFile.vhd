library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity RegFile is

  generic(WIDTH : integer := DATA_WIDTH);
 
  port( sysCLK 		: in std_logic;
        sysRST 		: in std_logic;
	write_enable	: in std_logic;
	rs1		: in std_logic_vector(4 downto 0);
	rs2		: in std_logic_vector(4 downto 0);
	rd		: in std_logic_vector(4 downto 0);
	data		: in std_logic_vector(WIDTH-1 downto 0);
	rOut1		: out std_logic_vector(WIDTH-1 downto 0);
	rOut2		: out std_logic_vector(WIDTH-1 downto 0));

end RegFile;

architecture structure of RegFile is
  
  component nbit_Reg
    port(CLK 		: in std_logic;
         RST 		: in std_logic;
	 wEnable	: in std_logic;
	 inData		: in std_logic_vector(WIDTH-1 downto 0);
	 outData	: out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component decoder5t32
    port(SEL		: in std_logic_vector(4 downto 0);
	 enable		: in  STD_LOGIC;
	 OUTPUT		: out std_logic_vector(31 downto 0));
  end component;

  component mux32t1
    port(SEL            : in std_logic_vector(4 downto 0);
         bus_in		: in t_bus_32x32;
         OUTPUT 	: out std_logic_vector(31 downto 0));
  end component;

  signal write_reg_select : std_logic_vector(31 downto 0);
  signal read_reg	  : t_bus_32x32;
  
begin
    DEC: decoder5t32 port map(
		SEL	 => rd,
		enable   => write_enable,
		OUTPUT	 => write_reg_select);

    MUX1: mux32t1 port map(
		SEL	 => rs1,
		bus_in	 => read_reg,
		OUTPUT   => rOut1);

    MUX2: mux32t1 port map(
		SEL	 => rs2,
		bus_in	 => read_reg,
		OUTPUT   => rOut2);

    REG: for i in 0 to WIDTH-1 generate
       REG: nbit_Reg port map(
		CLK      => sysCLK,
		RST      => sysRST,
		wEnable	 => write_reg_select(i),
		inData	 => data, 
		outData	 => read_reg(i));
    end generate REG;







end structure;