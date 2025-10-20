library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RISCV_types.all;

entity imm_generator is
    generic (WIDTH : natural := 32);
    port (
        input  : in  std_logic_vector(WIDTH-1 downto 0);
        output : out std_logic_vector(WIDTH-1 downto 0));
end imm_generator;

architecture Behavioral of imm_generator is
    constant R_type_opcode      : std_logic_vector(6 downto 0) := "0110011";
    constant SB_type_opcode     : std_logic_vector(6 downto 0) := "1100011";
    constant S_type_opcode      : std_logic_vector(6 downto 0) := "0100011";
    constant jal_opcode         : std_logic_vector(6 downto 0) := "1101111";
    constant I_type_load_opcode : std_logic_vector(6 downto 0) := "0000011";
    constant I_type_aImm_opcode : std_logic_vector(6 downto 0) := "0010011";
    constant jalr_opcode        : std_logic_vector(6 downto 0) := "1100111";
    constant auipc_opcode       : std_logic_vector(6 downto 0) := "0010111";
    constant lui_opcode         : std_logic_vector(6 downto 0) := "0110111";

    signal concatI, concatS  : std_logic_vector(11 downto 0);
    signal concatSB : std_logic_vector(12 downto 0);
    signal concatU  : std_logic_vector(19 downto 0);
    signal concatJ  : std_logic_vector(20 downto 0);
    
    signal outItype, outStype, outSBtype, outUtype, outJtype, outAUIPC, shiftedAUIPC : std_logic_vector(31 downto 0);

begin
    -- I-type: imm[11:0] = inst[31:20]
    concatI <= input(31 downto 20);
    
    -- S-type: imm[11:5] = inst[31:25], imm[4:0] = inst[11:7]
    concatS <= input(31 downto 25) & input(11 downto 7);
    
    -- SB-type (Branch): imm[12|10:5|4:1|11] = inst[31|30:25|11:8|7]
    concatSB <= input(31) & input(7) & input(30 downto 25) & input(11 downto 8) & '0';
    
    -- U-type: imm[31:12] = inst[31:12], imm[11:0] = 0
    concatU <= input(31 downto 12);
    
    -- J-type (JAL): imm[20|10:1|11|19:12] = inst[31|30:21|20|19:12]
    concatJ <= input(31) & input(19 downto 12) & input(20) & input(30 downto 21) & '0';

    -- Sign-extend immediates
    outItype  <= std_logic_vector(resize(signed(concatI), WIDTH));
    outStype  <= std_logic_vector(resize(signed(concatS), WIDTH));
    outSBtype <= std_logic_vector(resize(signed(concatSB), WIDTH));
    outUtype  <= concatU & x"000";  -- U-type shifts left 12 bits (no sign extension)
    outJtype  <= std_logic_vector(resize(signed(concatJ), WIDTH));
    outAUIPC  <= std_logic_vector(resize(signed(concatU), WIDTH));  -- Additional 10-bit shift for AUIPC

    shiftedAUIPC <= std_logic_vector(shift_left(signed(outAUIPC), 12));

    -- Output selection based on opcode
    output <= outItype  when (input(6 downto 0) = I_type_aImm_opcode or 
                              input(6 downto 0) = I_type_load_opcode or 
                              input(6 downto 0) = jalr_opcode) else
              outStype  when (input(6 downto 0) = S_type_opcode) else
              outSBtype when (input(6 downto 0) = SB_type_opcode) else
              outJtype  when (input(6 downto 0) = jal_opcode) else
              outUtype  when (input(6 downto 0) = lui_opcode) else
              shiftedAUIPC  when (input(6 downto 0) = auipc_opcode) else
              x"00000000";
           
end architecture Behavioral;