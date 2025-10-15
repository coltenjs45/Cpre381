library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity tb_ALUUnit is
end entity tb_ALUUnit;

architecture sim of tb_ALUUnit is
    constant WIDTH : integer := DATA_WIDTH;

    component ALUUnit is
        port(
            Alucontrol     : in  std_logic_vector(3 downto 0);
            flag_mux       : in  std_logic_vector(1 downto 0);
            input_A        : in  std_logic_vector(WIDTH-1 downto 0);
            input_B        : in  std_logic_vector(WIDTH-1 downto 0);
            output_result  : out std_logic_vector(WIDTH-1 downto 0);
            flag           : out std_logic
        );
    end component;
     
    -- Test signals 
    signal Alucontrol    : std_logic_vector(3 downto 0);
    signal flag_mux      : std_logic_vector(1 downto 0);
    signal input_A       : std_logic_vector(WIDTH-1 downto 0);
    signal input_B       : std_logic_vector(WIDTH-1 downto 0);
    signal output_result : std_logic_vector(WIDTH-1 downto 0);
    signal flag          : std_logic;

begin

    -- DUT (Device Under Test)
    dut: ALUUnit
        port map (
            Alucontrol    => Alucontrol,
            flag_mux      => flag_mux,
            input_A       => input_A,
            input_B       => input_B,
            output_result => output_result,
            flag          => flag
        );

    -- Stimulus process
    stimulus: process
    begin
        -- ADD
        Alucontrol <= "0011";
        flag_mux <= "00";
        input_A <= x"00000001";
        input_B <= x"00000001";
        wait for 10 ns;
        
        -- SUB
        Alucontrol <= "0100";
        flag_mux <= "00";
        input_A <= x"0000000F";
        input_B <= x"0000000D";
        wait for 10 ns;

        -- AND
        Alucontrol <= "0000";
        flag_mux <= "00";
        input_A <= x"00000007";
        input_B <= x"00000005";
        wait for 10 ns;

        -- OR
        Alucontrol <= "0001";
        flag_mux <= "00";
        input_A <= x"0000000F";
        input_B <= x"00000000";
        wait for 10 ns;

        -- XOR
        Alucontrol <= "0010";
        flag_mux <= "00";
        input_A <= x"0000000F";
        input_B <= x"0000000E";
        wait for 10 ns;

        -- ZERO flag (1 - 1)
        Alucontrol <= "0100";
        flag_mux <= "11";
        input_A <= x"00000001";
        input_B <= x"00000001";
        wait for 10 ns;

        -- NEG flag (0 - 1)
        Alucontrol <= "0100";
        flag_mux <= "00";
        input_A <= x"00000000";
        input_B <= x"00000001";
        wait for 10 ns;

        -- CARRY flag (max unsigned +1)
        Alucontrol <= "0011";
        flag_mux <= "10";
        input_A <= x"00000001";
        input_B <= x"FFFFFFFF";
        wait for 10 ns;

        -- OVERFLOW flag (+max + 1)
        Alucontrol <= "0011";
        flag_mux <= "01";
        input_A <= x"7FFFFFFF";
        input_B <= x"00000001";
        wait for 10 ns;

        -- slt
        -- if rs1<rs2 
        -- rs1 - rs2 = neg
        Alucontrol <= 0100;
        flag_mux <= "00";
        input_A <= x"0000009";
        input_b <= x"000000F";
        wait for 10 ns

        wait; -- stop simulation
    end process;

end architecture sim;