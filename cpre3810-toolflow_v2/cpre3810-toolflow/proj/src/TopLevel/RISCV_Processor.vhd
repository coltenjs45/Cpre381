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
  generic(N : integer := 32;
          ADDR_WIDTH : integer := 10;
          DATA_WIDTH : integer := 32);
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
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 111 0011)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer := 10;
            DATA_WIDTH : integer := 32);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((32-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((32 -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  component pcFetch is
    generic(WIDTH : integer := 32);
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
    generic (WIDTH : integer := 32);
    port(
      Alucontrol : in std_logic_vector(3 downto 0);
      flag_mux : in std_logic_vector(1 downto 0);
      input_A : in std_logic_vector (WIDTH-1 downto 0);
      input_B : in std_logic_vector (WIDTH-1 downto 0);
      output_result : out std_logic_vector (WIDTH-1 downto 0);
      overflowFlag : out std_logic;
      flag : out std_logic);
  end component;

  component BarrelShifter is
    generic (WIDTH : integer := 32);
      port(
      input           : in std_logic_vector(WIDTH-1 downto 0);
      ALUinput        : in std_logic_vector(WIDTH-1 downto 0);
      shiftAmnt       : in std_logic_vector(WIDTH-1 downto 0);
      control         : in std_logic_vector(3 downto 0);
      output          : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component controlUnit is
    generic(WIDTH : integer := 32);
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
      Shift         : out std_logic;
      ALUorImmJump  : out std_logic;
      FlagMux       : out std_logic_vector(1 downto 0);
      FlagOrNFlag   : out std_logic;
      JumpWReg      : out std_logic;
      HaltSignal    : out std_logic);

  end component;

  component imm_generator is
    generic (WIDTH : natural := 32);
    port (
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  component RegFile is
  generic(WIDTH : integer := 32);
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

  component mux2t1_dataflow
    port(
      SEL     : in std_logic;
      iA 		  : in std_logic;
      iB 		  : in std_logic;
      OUTPUT 	: out std_logic);
  end component;

  component mux2t1_N
    port(
      i_S          : in std_logic;
      i_D0         : in std_logic_vector(N-1 downto 0);
      i_D1         : in std_logic_vector(N-1 downto 0);
      o_O          : out std_logic_vector(N-1 downto 0));
  end component;

component mux32x4t1 is
  port(
    sel       : in std_logic_vector(1 downto 0);
    bus_in		: in t_bus_4x32;
    o_output 	: out std_logic_vector(31 downto 0));
end component;

component invg is
  port(
    i_A          : in std_logic;
    o_F          : out std_logic);
end component;

component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component zero_extender is
  generic (OUT_WIDTH : natural := 32);
    port (
        input     : in std_logic;
        output    : out std_logic_vector(OUT_WIDTH-1 downto 0));
end component;

  --Control Unit signals
  signal s_ALUsrc, s_MemToReg, s_Branch, s_Jump, s_Shift, s_ALUorImmJump, s_FlagOrNFlag, s_JumpWReg : std_logic;
  signal s_ALUctrl : std_logic_vector(3 downto 0);
  signal s_ImmType, s_AndLink, s_FlagMux: std_logic_vector(1 downto 0);

  --Fetch Unit Signals
  signal s_pcUp4, s_pcUpImm : std_logic_vector(32-1 downto 0);
  signal s_branchFlags, s_branchLogic, s_BranchOrJump : std_logic;

  --Immediate Generator Signals
  signal s_immediate : std_logic_vector(32-1 downto 0);

  --ALU Unit Signals
  signal s_ALUresult, s_inputA, s_inputB : std_logic_vector(32-1 downto 0);
  signal s_flag, s_notFlag : std_logic;

  --Barrel Shifter Signals
  signal s_BSresult : std_logic_vector(32-1 downto 0);

  --Reg File Signals ***CHECK REQUIRED SIGNALS***
  signal s_rOut2 : std_logic_vector(32-1 downto 0);

  --32x4t1 bus for WriteBack
  signal s_writeback : t_bus_4x32;
  signal s_extFlag, s_CPUout : std_logic_vector(32-1 downto 0);

  -- BS or ALU mux
  signal s_result : std_logic_vector(32-1 downto 0);
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
      MemWrite      => s_DMemWr,
      RegWrite      => s_RegWr,
      MemToReg      => s_MemToReg,
      Branch        => s_Branch,
      Jump          => s_Jump,
      Shift         => s_Shift,
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
      immediate        => s_immediate,
      register_plusImm => s_ALUresult,
      pcUp4            => s_pcUp4,
      pcUpImm          => s_pcUpImm,
      programCounter   => s_NextInstAddr);

  ImmGen : imm_generator
    port map(
      input   => s_Inst,
      output  => s_immediate);

  ALU : ALUUNit
    port map(
      Alucontrol    => s_ALUctrl,
      flag_mux      => s_FlagMux,
      input_A       => s_inputA,
      input_B       => s_inputB,
      output_result => s_ALUresult,
      overflowFlag  => s_Ovfl,
      flag          => s_flag);

  s_DMemAddr <= s_ALUresult;
  oALUOut <= s_ALUresult;

  Shifter : barrelShifter
    port map (
      input       => s_inputA,
      ALUinput    => s_ALUresult,
      shiftAmnt   => s_immediate,
      control     => s_ALUctrl,
      output      => s_BSresult);

  s_RegWrAddr <= s_Inst(11 downto 7);

  Registers : RegFile
    port map(
      sysCLK 		    => iCLK,
      sysRST 		    => iRST,
	    write_enable	=> s_RegWr,
      rs1	        	=> s_Inst(19 downto 15),
      rs2		        => s_Inst(24 downto 20),
      rd		        => s_RegWrAddr,
      data		      => s_RegWrData,
      rOut1		      => s_inputA,
      rOut2		      => s_rOut2);  
      
  InputBMux : mux2t1_N
    port map(
      i_S   => s_ALUsrc,
      i_D0  => s_rOut2,
      i_D1  => s_immediate,
      o_O   => s_inputB);

  ALUorBSmux : mux2t1_N
    port map(
      i_S   => s_Shift,
      i_D0  => s_ALUresult,
      i_D1  => s_BSresult,
      o_O   => s_result); 

  flagExtender : zero_extender
    port map(
      input => s_flag,
      output => s_extFlag);

  s_writeback(0) <= s_result;  -- ALU/BS mux output
  s_writeback(1) <= s_pcUp4;
  s_writeback(2) <= s_extFlag;
  s_writeback(3) <= s_pcUpImm;

  WriteBackSelectMux : mux32x4t1
    port map(
      sel        => s_AndLink,
      bus_in		 => s_writeback,
      o_output 	 => s_CPUout);

  MemOrCPUmux : mux2t1_N
    port map(
      i_S   => s_MemToReg,
      i_D0  => s_DMemOut,
      i_D1  => s_CPUout,
      o_O   => s_RegWrData); 

  flagNot : invg
    port map(
      i_A => s_flag,
      o_F => s_notFlag);

  FlagOrNot : mux2t1_dataflow
    port map(
      SEL     => s_FlagOrNFlag,
      iA 		  => s_flag,
      iB 		  => s_notFlag,
      OUTPUT 	=> s_branchFlags);

  branchAnd : andg2
    port map(
      i_A => s_Branch,
      i_B => s_branchFlags,
      o_F => s_branchLogic);

  branchJump : org2
    port map(
      i_A => s_branchLogic,
      i_B => s_Jump,
      o_F => s_BranchOrJump);

end structure;
