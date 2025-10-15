-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- RISCV_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a RISCV_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.RISCV_types.all;

entity RISCV_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  RISCV_Processor;


architecture structure of RISCV_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 001 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component pcFetch is
    generic(WIDTH : integer := DATA_WIDTH);
    port(
      clock               : in std_logic;
      reset               : in std_logic;
      conditionBJ         : in std_logic;
      jump                : in std_logic;
      jumpWithRegister    : in std_logic;
      immediate           : in std_logic_vector(WIDTH-1 downto 0);
      register_plusImm    : in std_logic_vector(WIDTH-1 downto 0);
      pcUp4               : out std_logic_vector(WIDTH-1 downto 0);
      pcUpImm             : out std_logic_vector(WIDTH-1 downto 0);
      programCounter      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component ALUUnit is
    generic (WIDTH : integer := DATA_WIDTH);
    port(
      Alucontrol : in std_logic_vector(3 downto 0);
      flag_mux : in std_logic_vector(1 downto 0);
      input_A : in std_logic_vector (WIDTH-1 downto 0);
      input_B : in std_logic_vector (WIDTH-1 downto 0);
      output_result : out std_logic_vector (WIDTH-1 downto 0);
      flag : out std_logic);
  end component;

  component BarrelShifter is
    generic (WIDTH : integer := DATA_WIDTH);
      port(
      input           : in std_logic_vector(WIDTH-1 downto 0);
      shiftAmnt       : in std_logic_vector(WIDTH-1 downto 0);
      control         : in std_logic_vector(3 downto 0);
      output          : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component controlUnit is
    generic(WIDTH : integer := DATA_WIDTH);
      port(
      opcode        : in std_logic_vector(6 downto 0);
      funct3        : in std_logic_vector(2 downto 0);
      funct7        : in std_logic_vector(6 downto 0);
      ALUsrc        : out std_logic;
      ALUctrl       : out std_logic_vector(3 downto 0);
      ImmType       : out std_logic_vector(1 downto 0);
      AndLink       : out std_logic_vector(1 downto 0);
      MemWrite      : out std_logic;
      RegWrite      : out std_logic;
      MemToReg      : out std_logic;
      Branch        : out std_logic;
      Jump          : out std_logic;
      ALUorImmJump  : out std_logic;
      FlagMux       : out std_logic_vector(1 downto 0);
      FlagOrNFlag   : out std_logic;
      JumpWReg      : out std_logic;
      HaltSignal    : out std_logic);

  end component;

  component imm_generator is
    generic (WIDTH : natural := DATA_WIDTH);
    port (
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component RegFile is
  generic(WIDTH : integer := DATA_WIDTH);
  port(
    sysCLK 		    : in std_logic;
    sysRST 		    : in std_logic;
	  write_enable	: in std_logic;
	  rs1	        	: in std_logic_vector(4 downto 0);
	  rs2		        : in std_logic_vector(4 downto 0);
	  rd		        : in std_logic_vector(4 downto 0);
	  data		      : in std_logic_vector(WIDTH-1 downto 0);
	  rOut1		      : out std_logic_vector(WIDTH-1 downto 0);
	  rOut2		      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  --Control Unit signals
  signal s_ALUsrc, s_MemWrite, s_RegWrite, s_MemToReg, s_Branch, s_Jump, s_ALUorImmJump, s_FlagOrNFlag, s_JumpWReg : std_logic;
  signal s_ALUctrl : std_logic_vector(3 downto 0);
  signal s_ImmType, s_AndLink, s_FlagMux: std_logic_vector(1 downto 0);

  --Fetch Unit Signals
  signal s_pcUp4, s_pcUpImm : std_logic_vector(DATA_WIDTH-1 downto 0);


  -- ASSIGNMENTS
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 001 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  CTRLunit : controlUnit
    port map(
      opcode        => s_Inst(6 downto 0),
      funct3        => s_Inst(14 downto 12),
      funct7        => s_Inst(31 downto 25),
      ALUsrc        => s_ALUsrc,
      ALUctrl       => s_ALUctrl,
      ImmType       => s_ImmType,
      AndLink       => s_AndLink,
      MemWrite      => s_MemWrite,
      RegWrite      => s_RegWrite,
      MemToReg      => s_MemToReg,
      Branch        => s_Branch,
      Jump          => s_Jump,
      ALUorImmJump  => s_ALUorImmJump,
      FlagMux       => s_FlagMux,
      FlagOrNFlag   => s_FlagOrNFlag,
      JumpWReg      => s_JumpWReg,
      HaltSignal    => s_Halt);

  FetchUnit : pcFetch
    port map(
      clock            => iCLK,
      reset            => iRST,
      conditionBJ      => s_BranchOrJump,
      jump             => s_ALUorImmJump,
      jumpWithRegister => s_JumpWReg,
      immediate        => s_immediate
      register_plusImm => ???,
      pcUp4            => s_pcUp4,
      pcUpImm          => s_pcUpImm,
      programCounter   => s_NextInstAddr);

  ImmGen : imm_generator
    port map(
      input   => s_Inst,
      output  => s_immediate);


end structure;

