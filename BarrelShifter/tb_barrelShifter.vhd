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
  
  component BarrelShifter
    generic(WIDTH : integer := 32);
    port(
        input           : in std_logic_vector(WIDTH-1 downto 0);
        shiftAmnt       : in std_logic_vector(WIDTH-1 downto 0);
        control         : in std_logic_vector(1 downto 0);
        output          : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  signal s_CLK : std_logic;
  signal s_control : std_logic_vector(1 downto 0);
  signal s_input, s_shiftAmnt, s_output : std_logic_vector(31 downto 0);



begin

  DUT: BarrelShifter 
  port map(
        input      => s_input,
        shiftAmnt  => s_shiftAmnt,
        control    => s_control,
        output     => s_output);
  
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
    
    s_input     <= x"0000000F";
    s_shiftAmnt <= x"00000002";
    s_control   <= "00";
    wait for gCLK_HPER * 2;

    s_input     <= x"800000F0";
    s_shiftAmnt <= x"00000004";
    s_control   <= "10";
    wait for gCLK_HPER * 2;

    s_input     <= x"80000000";
    s_shiftAmnt <= x"00000003";
    s_control   <= "11";
    wait for gCLK_HPER * 2;

    wait;
  end process;
  
end behavior;