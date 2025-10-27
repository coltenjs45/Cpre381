library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity tb_ALUUnit is
end entity;

architecture sim of tb_ALUUnit is
    constant WIDTH : integer := 32;

    component ALUUnit
    generic (WIDTH : integer := 32);
    port(
        Alucontrol : in std_logic_vector(3 downto 0);
        flag_mux : in std_logic_vector(1 downto 0);
        input_A : in std_logic_vector (WIDTH-1 downto 0);
        input_B : in std_logic_vector (WIDTH-1 downto 0);
        output_result : out std_logic_vector (WIDTH-1 downto 0);
        overflowFlag: out std_logic;
        flag : out std_logic
    );
    end component;

    -- DUT Signals
    signal Alucontrol    : std_logic_vector(3 downto 0);
    signal flag_mux      : std_logic_vector(1 downto 0);
    signal input_A       : std_logic_vector(WIDTH-1 downto 0);
    signal input_B       : std_logic_vector(WIDTH-1 downto 0);
    signal output_result : std_logic_vector(WIDTH-1 downto 0);
    signal overflowFlag  : std_logic;
    signal flag          : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    -- DUT Instance
    DUT: ALUUnit
        generic map(WIDTH => WIDTH)
        port map(
            Alucontrol    => Alucontrol,
            flag_mux      => flag_mux,
            input_A       => input_A,
            input_B       => input_B,
            output_result => output_result,
            overflowFlag  => overflowFlag,
            flag          => flag
        );

    -- Test Process
    process
    begin
        -- Initialize
        input_A <= (others => '0');
        input_B <= (others => '0');
        Alucontrol <= (others => '0');
        flag_mux <= (others => '0');
        wait for 10 ns;

        -- AND Test
        input_A <= x"0000FFFF";
        input_B <= x"00FF00FF";
        Alucontrol <= "0000";  -- AND
        flag_mux <= "00";
        wait for 10 ns;
        
        -- OR Test
        input_A <= x"0000FFFF";
        input_B <= x"00FF00FF";
        Alucontrol <= "0001";  -- OR
        wait for 10 ns;
        

        -- XOR Test
        input_A <= x"F0F0F0F0";
        input_B <= x"0F0F0F0F";
        Alucontrol <= "0010";  -- XOR
        wait for 10 ns;
        

        -- ADD Test
        input_A <= std_logic_vector(to_unsigned(10, WIDTH));
        input_B <= std_logic_vector(to_unsigned(20, WIDTH));
        Alucontrol <= "0011"; -- ADD
        flag_mux <= "10";     -- check carry
        wait for 10 ns;
        
        -- SUB Test
        input_A <= std_logic_vector(to_unsigned(25, WIDTH));
        input_B <= std_logic_vector(to_unsigned(5, WIDTH));
        Alucontrol <= "0100"; -- SUB
        flag_mux <= "11";     -- check zero
        wait for 10 ns;
        
        -- SLT Test
        input_A <= std_logic_vector(to_signed(-5, WIDTH));
        input_B <= std_logic_vector(to_signed(2, WIDTH));
        Alucontrol <= "0100"; -- SUB/SLT operation
        flag_mux <= "01";     -- select SLT flag
        wait for 10 ns;
        
        -- Overflow Test
        input_A <= x"7FFFFFFF";
        input_B <= x"00000001";
        Alucontrol <= "0011"; -- ADD
        flag_mux <= "10";     -- check carry
        wait for 10 ns;
        

        -- Negative Test
        input_A <= std_logic_vector(to_signed(10, WIDTH));
        input_B <= std_logic_vector(to_signed(-20, WIDTH));
        Alucontrol <= "0011"; -- ADD
        flag_mux <= "00";     -- check neg
        wait for 10 ns;
        

        -- Zero Test
        input_A <= std_logic_vector(to_signed(10, WIDTH));
        input_B <= std_logic_vector(to_signed(10, WIDTH));
        Alucontrol <= "0100"; -- SUB
        flag_mux <= "11";     -- check zero
        wait for 10 ns;
        

        wait;
    end process;
end architecture;