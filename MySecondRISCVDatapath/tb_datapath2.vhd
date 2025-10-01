library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.my_package.all;

entity tb_datapath2 is
  generic(gCLK_HPER   : time := 50 ns);
  end tb_datapath2;

architecture behavior of tb_datapath2 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  

  component datapath2
    port( 
	CLK		: in std_logic;
	RST		: in std_logic;
	reg_write	: in std_logic;
	mem_write	: in std_logic;
	memToReg	: in std_logic;
	ALUsrc		: in std_logic;
	add_sub		: in std_logic;
	read1		: in std_logic_vector(4 downto 0);
	read2		: in std_logic_vector(4 downto 0);
	write_sel	: in std_logic_vector(4 downto 0);
	immediate	: in std_logic_vector(15 downto 0));
  end component;

  signal s_CLK, S_RST, s_regWrite, s_memWrite, s_memToReg, s_ALUsrc, s_addsub : std_logic;
  signal s_read1, s_read2, s_write : std_logic_vector(4 downto 0);
  signal s_immediate : std_logic_vector(15 downto 0);

begin

  DUT: datapath2 
  port map(
	CLK		=> s_CLK,
	RST		=> s_RST,
	reg_write	=> s_regWrite,
	mem_write	=> s_memWrite,
	memToReg	=> s_memToReg,
	ALUsrc		=> s_ALUsrc,
	add_sub		=> s_addSub,
	read1		=> s_read1,
	read2		=> s_read2,
	write_sel	=> s_write,
	immediate	=> s_immediate);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER; 
    s_CLK <= '1';
    wait for gCLK_HPER; 
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    s_RST	<= '1';
    wait for gCLK_HPER/2;
    s_RST	<= '0';
    
    --instruction 1
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(0, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(25, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 2
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(0, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(26, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(256, 16));
    wait for cCLK_PER;  

    --instruction 3
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 4
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(1, 16));
    wait for cCLK_PER;  

    --instruction 5
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 6
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(26, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 7
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(2, 16));
    wait for cCLK_PER;  

    --instruction 8
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 9
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(26, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(1, 16));
    wait for cCLK_PER;  

    --instruction 10
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(3, 16));
    wait for cCLK_PER;     

    --instruction 11
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER; 

    --instruction 12
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(26, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(2, 16));
    wait for cCLK_PER;  

    --instruction 13
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(4, 16));
    wait for cCLK_PER;  

    --instruction 14
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 15
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(26, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(3, 16));
    wait for cCLK_PER;  

    --instruction 16
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(5, 16));
    wait for cCLK_PER;  

    --instruction 17
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;  

    --instruction 18
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(26, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(4, 16));
    wait for cCLK_PER;  

    --instruction 19
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(25, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(2, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(6, 16));
    wait for cCLK_PER;  

    --instruction 20
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '0';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(1, 5));
    s_read2	<= std_logic_vector(to_unsigned(2, 5));
    s_write	<= std_logic_vector(to_unsigned(1, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(0, 16));
    wait for cCLK_PER;     

    --instruction 21
    s_regWrite	<= '1';
    s_memWrite	<= '0';
    s_memToReg	<= '1';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(0, 5));
    s_read2	<= std_logic_vector(to_unsigned(0, 5));
    s_write	<= std_logic_vector(to_unsigned(27, 5));
	
    s_immediate	<= std_logic_vector(to_unsigned(512, 16));
    wait for cCLK_PER;  

    --instruction 22
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(27, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_signed(-1, 16));
    wait for cCLK_PER;  

    --instruction 23
    s_regWrite	<= '0';
    s_memWrite	<= '1';
    s_memToReg	<= '0';
    s_ALUsrc	<= '1';
    s_addSub	<= '0';

    s_read1	<= std_logic_vector(to_unsigned(27, 5));
    s_read2	<= std_logic_vector(to_unsigned(1, 5));
    s_write	<= std_logic_vector(to_unsigned(0, 5));
	
    s_immediate	<= std_logic_vector(to_signed(-1, 16));
    wait for cCLK_PER; 

    wait;
  end process;
  
end behavior;