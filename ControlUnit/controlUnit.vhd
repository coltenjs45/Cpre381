library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity controlUnit is
  generic(WIDTH : integer := 32);
 
  port(
    opcode             : in std_logic_vector(6 downto 0);
    funct3             : in std_logic_vector(3 downto 0);
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
    JumpWithRegister   : out std_logic);

end controlUnit;

architecture dataflow of pcFetch is
    constant R_type_opcode = std_logic_vector(6 downto 0) := "0110011";
    constant SB_type_opcode = std_logic_vector(6 downto 0) := "1100011";
    constant S_type_opcode = std_logic_vector(6 downto 0) := "0100011";
    constant jal_opcode = std_logic_vector(6 downto 0) := "1101111";

    constant I_type_load_opcode = std_logic_vector(6 downto 0) := "0000011";
    constant I_type_aImm_opcode = std_logic_vector(6 downto 0) := "0010011";
    constant jalr_opcode = std_logic_vector(6 downto 0) := "1100111"
    constant auipc_opcode = std_logic_vector(6 downto 0) := "0010111";
    constant lui_opcode = std_logic_vector(6 downto 0) := "0110111"

    ALUsrc <= '1' when (opcode = I_type_aImm_opcode) else
              '1' when (opcode = I_type_load_opcode) else
              '1' when (opcode = S_type_opcode) else
              '1' when (opcode = jalr_opcode) else
              '1' when (opcode = lui_opcode) else
              '0' when (opcode = R_type_opcode) else
              '0' when (opcode = SB_type_opcode) else
              '0';
    
    ALUctrl <=  "0000" when(opcode = R_type_opcode and funct3 = "111") else
                "0000" when(opcode = I_type_aImm_opcode and funct3 = "111") else
                "0001" when(opcode = R_type_opcode and funct3 = "110") else
                "0001" when(opcode = I_type_aImm_opcode and funct3 = "110") else
                "0010" when(opcode = R_type_opcode and funct3 = "100") else
                "0010" when(opcode = I_type_aImm_opcode and funct3 = "100") else
                "0011" when(opcode = R_type_opcode and funct3 = "000") else
                "0011" when(opcode = I_type_aImm_opcode and funct3 = "000") else
                "0011" when(opcode = I_type_load_opcode or opcode = S_type_opcode or opcode = jalr_opcode) else
                "0100" when(opcode = R_type_opcode and funct3 = "000" and funct7 = "0100000") else
                "0100" when(opcode = R_type_opcode and funct3 = "010" and funct7 = "0000000") else
                "0100" when(opcode = I_type_aImm_opcode and (funct3 = "010" or funct3 = "011")) else
                "0100" when(opcode = SB_type_opcode) else
                "0101" when(opcode = R_type_opcode and funct3 = "101" and funct7 = "0000000") else
                "0101" when(opcode = I_type_aImm_opcode and funct3 = "101" and funct7 = "0000000") else
                "0110" when(opcode = R_type_opcode and funct3 = "101" and funct7 = "0100000") else
                "0110" when(opcode = I_type_aImm_opcode and funct3 = "101" and funct7 = "0100000") else
                "0111" when(opcode = R_type_opcode and funct3 = "001" and funct7 = "0000000") else
                "0111" when(opcode = I_type_aImm_opcode and funct3 = "001" and funct7 = "0000000") else
                "1000" when(opcode = lui_opcode);
                "1111";              
    
    ImmType <=  "00" when(opcode = I_type_aImm_opcode and (funct3 = "011" or funct3 = "001" or funct3 = "101")) else
                "00" when(opcode = SB_type_opcode and (funct3 = "110" or funct3 = "111")) else
                "01" when(opcode = I_type_aImm_opcode and (funct3 = "000" or funct3 = "010" or funct3 = "100" or funct3 = "110" or funct3 = "111")) else
                "01" when(opcode = I_type_load_opcode) else
                "01" when(opcode = S_type_opcode) else
                "01" when(opcode = jalr_opcode) else
                "01" when(opcode = SB_type_opcode and (funct3 = "000" or funct3 = "001" or funct3 = "100" or funct3 = "101")) else
                "11" when(opcode = lui_opcode) else
                "11" when(opcode = jal_opcode) else
                "11" when(opcode = auipc_opcode) else         
                "01";

    AndLink <=  "00" when(opcode = R_type_opcode and (funct3 /= "010")) else
                "00" when(opcode = I_type_load_opcode) else
                "00" when(opcode = lui_opcode) else
                "00" when(opcode = I_type_aImm_opcode and (funct3 /= "010" or funct3 /= "011")) else
                "01" when(opcode = jal_opcode) else
                "01" when(opcode = jalr_opcode) else         
                "10" when(opcode = R_type_opcode and funct3 = "010") else
                "10" when(opcode = I_type_aImm_opcode and (funct3 = "010" or funct3 = "011")) else
                "11" when(opcode = auipc_opcode);
                "00";
              


end dataflow;