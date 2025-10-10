library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity tb_controlUnit is
  generic(gCLK_HPER   : time := 50 ns);
  end tb_controlUnit;

architecture behavior of tb_controlUnit is
  
  constant R_type_opcode  : std_logic_vector(6 downto 0) := "0110011";
  constant SB_type_opcode : std_logic_vector(6 downto 0) := "1100011";
  constant S_type_opcode  : std_logic_vector(6 downto 0) := "0100011";
  constant jal_opcode     : std_logic_vector(6 downto 0) := "1101111";
  constant I_type_load_opcode : std_logic_vector(6 downto 0) := "0000011";
  constant I_type_aImm_opcode : std_logic_vector(6 downto 0) := "0010011";
  constant jalr_opcode  : std_logic_vector(6 downto 0) := "1100111";
  constant auipc_opcode : std_logic_vector(6 downto 0) := "0010111";    
  constant lui_opcode   : std_logic_vector(6 downto 0) := "0110111";
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  component controlUnit
    generic(WIDTH : integer := 32);
    port(
      opcode             : in std_logic_vector(6 downto 0);
      funct3             : in std_logic_vector(2 downto 0);
      funct7             : in std_logic_vector(6 downto 0);
      ALUsrc             : out std_logic;
      ALUctrl            : out std_logic_vector(3 downto 0);
      ImmType            : out std_logic_vector(1 downto 0);
      AndLink            : out std_logic_vector(1 downto 0);
      MemWrite           : out std_logic;
      RegWrite           : out std_logic;
      MemToReg           : out std_logic;
      Branch             : out std_logic;
      Jump               : out std_logic;
      ALUorImmJump       : out std_logic;
      FlagMux            : out std_logic_vector(1 downto 0);
      FlagOrNFlag        : out std_logic;
      JumpWReg           : out std_logic);
  end component;

  signal s_CLK, s_ALUsrc, s_MemWrite, s_RegWrite, s_MemToReg, s_Branch, s_Jump, s_ALUorImmJump, s_FlagOrNFlag, s_JumpWReg : std_logic;
  signal s_ImmType, s_AndLink, s_FlagMux : std_logic_vector(1 downto 0);
  signal s_funct3 : std_logic_vector(2 downto 0);
  signal s_ALUctrl : std_logic_vector(3 downto 0);  
  signal s_opcode, s_funct7 : std_logic_vector(6 downto 0);



begin

  DUT: controlUnit 
  port map(
      opcode       => s_opcode,
      funct3       => s_funct3,
      funct7       => s_funct7,
      ALUsrc       => s_ALUsrc,
      ALUctrl      => s_ALUctrl,
      ImmType      => s_ImmType,
      AndLink      => s_AndLink,
      MemWrite     => s_MemWrite,
      RegWrite     => s_RegWrite,
      MemToReg     => s_MemToReg,
      Branch       => s_Branch,
      Jump         => s_Jump,
      ALUorImmJump => s_ALUorImmJump,
      FlagMux      => s_FlagMux,
      FlagOrNFlag  => s_FlagOrNFlag,
      JumpWReg     => s_JumpWReg);

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
    wait for gCLK_HPER/2;
    
    --ADDI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --ADD--
    s_opcode <= R_type_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --AND--
    s_opcode <= R_type_opcode;
    s_funct3 <= "111";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --ANDI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "111";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LUI--
    s_opcode <= lui_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LW--
    s_opcode <= I_type_load_opcode;
    s_funct3 <= "010";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --XOR--
    s_opcode <= R_type_opcode;
    s_funct3 <= "100";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --XORI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "100";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --OR--
    s_opcode <= R_type_opcode;
    s_funct3 <= "110";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --ORI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "110";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SLT--
    s_opcode <= R_type_opcode;
    s_funct3 <= "010";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SLTI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "010";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SLTUI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "011";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SLL--
    s_opcode <= R_type_opcode;
    s_funct3 <= "001";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SRL--
    s_opcode <= R_type_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SRA--
    s_opcode <= R_type_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0100000";
    wait for gCLK_HPER * 2;

    --SW--
    s_opcode <= S_type_opcode;
    s_funct3 <= "010";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SUB--
    s_opcode <= R_type_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0100000";
    wait for gCLK_HPER * 2;

    --BEQ--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --BNE--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "001";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --BLT--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "100";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --BGE--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --BLTU--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "110";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;    
   
    --BGEU--
    s_opcode <= SB_type_opcode;
    s_funct3 <= "111";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --JAL--
    s_opcode <= jal_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --JALR--
    s_opcode <= jalr_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LB--
    s_opcode <= I_type_load_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LH--
    s_opcode <= I_type_load_opcode;
    s_funct3 <= "001";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LBU--
    s_opcode <= I_type_load_opcode;
    s_funct3 <= "100";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --LHU--
    s_opcode <= I_type_load_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SLLI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "001";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    --SRLI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2; 
    
    --SRAI--
    s_opcode <= I_type_aImm_opcode;
    s_funct3 <= "101";
    s_funct7 <= "0100000";
    wait for gCLK_HPER * 2;

    --AUIPC--
    s_opcode <= auipc_opcode;
    s_funct3 <= "000";
    s_funct7 <= "0000000";
    wait for gCLK_HPER * 2;

    wait;
  end process;
  
end behavior;