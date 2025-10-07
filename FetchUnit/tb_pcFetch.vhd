library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISCV_types.all;

entity tb_pcFetch is
  generic(gCLK_HPER   : time := 50 ns);
  end tb_pcFetch;

architecture behavior of tb_pcFetch is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  component pcFetch
    generic(WIDTH : integer := 32);
    port(
        clock               : in std_logic;
        reset               : in std_logic;
        immediate           : in std_logic_vector(WIDTH-1 downto 0);
        register_plusImm    : in std_logic_vector(WIDTH-1 downto 0);
        muxCtrl             : in std_logic_vector(1 downto 0);
        nextInstruction     : out std_logic_vector(WIDTH-1 downto 0);
        programCounter      : out std_logic_vector(WIDTH-1 downto 0));
  end component;

  signal s_CLK, s_RST : std_logic;
  signal s_muxCtrl : std_logic_vector(1 downto 0);
  signal s_immediate, s_nextInstruction, s_regPlusImm, s_programCounter : std_logic_vector(31 downto 0);

begin

  DUT: pcFetch 
  port map(
        clock           => s_CLK,
        reset           => s_RST,
        immediate       => s_immediate,
       register_plusImm => s_regPlusImm,
        muxCtrl         => s_muxCtrl,
        nextInstruction => s_nextInstruction,
        programCounter  => s_programCounter);

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
    s_RST <= '1';
    wait for gCLK_HPER;
    s_RST <= '0';

    wait for gCLK_HPER;
    --Case 1--
    s_muxCtrl   <= "00";
    s_immediate <= x"00000000";

    wait for gCLK_HPER * 4;

    --Case 2--
    s_RST <= '1';
    wait for gCLK_HPER;
    s_RST <= '0';
    wait for gCLK_HPER;

    s_muxCtrl   <= "01";
    s_immediate <= x"00001000";
    wait for gCLK_HPER;
    s_muxCtrl   <= "00";
    wait for gCLK_HPER * 4;

    --Case 3--
    s_RST <= '1';
    wait for gCLK_HPER;
    s_RST <= '0';
    wait for gCLK_HPER;

    s_muxCtrl   <= "10";
    s_immediate <= x"00001000";
    wait for gCLK_HPER;
    s_muxCtrl   <= "00";
    wait for gCLK_HPER * 4;

    --Case 4--
    s_RST <= '1';
    wait for gCLK_HPER;
    s_RST <= '0';
    wait for gCLK_HPER;

    s_muxCtrl    <= "11";
    s_regPlusImm <= x"00001000";
    wait for gCLK_HPER;
    s_muxCtrl   <= "00";
    wait for gCLK_HPER * 4;

    wait;
  end process;
  
end behavior;