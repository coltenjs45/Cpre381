library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity tb_barrelShifter is
  generic(gCLK_HPER   : time := 50 ns);
  end tb_barrelShifter;

architecture behavior of tb_barrelShifter is
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  component barrel_shifter
    port (
      data_in  : in  std_logic_vector(31 downto 0);
      shamt    : in  std_logic_vector(4 downto 0);
      op       : in  std_logic_vector(1 downto 0);
      data_out : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s_CLK : std_logic;
  signal s_control : std_logic_vector(1 downto 0);
  signal s_shiftAmnt : std_logic_vector(4 downto 0);
  signal s_input, s_output : std_logic_vector(31 downto 0);



begin

  DUT: barrel_shifter 
  port map(
        data_in    => s_input,
        shamt      => s_shiftAmnt,
        op         => s_control,
        data_out   => s_output);
  
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
    
    -- Test 1: No shift (shamt = 0)
    s_input <= x"12345678";
    s_shiftAmnt <= "00000";
    s_control <= "00";
    wait for gCLK_HPER * 2;

    -- Test 2: Logical left shift by 4
    s_input <= x"12345678";
    s_shiftAmnt <= "00100";
    s_control <= "11";
    wait for gCLK_HPER * 2;

    -- Test 3: Logical right shift by 4
    s_input <= x"12345678";
    s_shiftAmnt <= "00100";
    s_control <= "01";
    wait for gCLK_HPER * 2;

    -- Test 4: Arithmetic right shift by 4 (negative number)
    s_input <= x"FEDCBA98";
    s_shiftAmnt <= "00100";
    s_control <= "10";
    wait for gCLK_HPER * 2;

    -- Test 5: Logical left shift by 16
    s_input <= x"0000ABCD";
    s_shiftAmnt <= "10000";
    s_control <= "11";
    wait for gCLK_HPER * 2;

    -- Test 6: Logical right shift by 16
    s_input <= x"ABCD0000";
    s_shiftAmnt <= "10000";
    s_control <= "01";
    wait for gCLK_HPER * 2;

    -- Test 7: Arithmetic right shift by 16 (negative)
    s_input <= x"ABCD0000";
    s_shiftAmnt <= "10000";
    s_control <= "10";
    wait for gCLK_HPER * 2;

    -- Test 8: Logical left shift by 31 (maximum)
    s_input <= x"00000001";
    s_shiftAmnt <= "11111";
    s_control <= "11";
    wait for gCLK_HPER * 2;

    -- Test 9: Arithmetic right shift by 31 (all ones result)
    s_input <= x"80000000";
    s_shiftAmnt <= "11111";
    s_control <= "10";
    wait for gCLK_HPER * 2;

    -- Test 10: Combined shift amount (7 = 1 + 2 + 4)
    s_input <= x"FFFFFFFF";
    s_shiftAmnt <= "00111";
    s_control <= "01";
    wait for gCLK_HPER * 2;

    wait;
  end process;
  
end behavior;