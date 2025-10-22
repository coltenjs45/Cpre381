library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
  port (
    data_in  : in  std_logic_vector(31 downto 0);
    shamt    : in  std_logic_vector(4 downto 0);
    op       : in  std_logic_vector(1 downto 0);
    data_out : out std_logic_vector(31 downto 0)
  );
end entity barrel_shifter;

architecture structural of barrel_shifter is

  -- Stage 0 signals (shift by 1)
  signal stage0_shifted : std_logic_vector(31 downto 0);
  signal stage0_out : std_logic_vector(31 downto 0);

  -- Stage 1 signals (shift by 2)
  signal stage1_shifted : std_logic_vector(31 downto 0);
  signal stage1_out : std_logic_vector(31 downto 0);

  -- Stage 2 signals (shift by 4)
  signal stage2_shifted : std_logic_vector(31 downto 0);
  signal stage2_out : std_logic_vector(31 downto 0);

  -- Stage 3 signals (shift by 8)
  signal stage3_shifted : std_logic_vector(31 downto 0);
  signal stage3_out : std_logic_vector(31 downto 0);

  -- Stage 4 signals (shift by 16)
  signal stage4_shifted : std_logic_vector(31 downto 0);

  -- Fill bit
  signal fill_bit : std_logic;

  -- Buses for 32x4t1
  signal stage0, stage1, stage2, stage3 : t_bus_4x32;

  component mux2t1_N
    generic(N : integer := 32);
    port(
      i_S          : in std_logic;
      i_D0         : in std_logic_vector(N-1 downto 0);
      i_D1         : in std_logic_vector(N-1 downto 0);
      o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component mux32x4t1
      port(
        sel       : in std_logic_vector(1 downto 0);
        bus_in	  : in t_bus_4x32;
        o_output 	: out std_logic_vector(31 downto 0));
  end component;

begin

  fill_bit <= data_in(31);

  -- ========== STAGE 0: Shift by 1 ==========
  stage0(3) <= data_in(30 downto 0) & '0';
  stage0(1) <= '0' & data_in(31 downto 1);
  stage0(2) <= fill_bit & data_in(31 downto 1);
  stage0(0) <= data_in;

  mux_stage0_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel      => op,
      bus_in   => stage0,
      o_output => stage0_shifted
    );

  mux_stage0_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      i_S  => shamt(0),
      i_D0 => data_in,
      i_D1 => stage0_shifted,
      o_O  => stage0_out
    );

  -- ========== STAGE 1: Shift by 2 ==========
  stage1(3) <= stage0_out(29 downto 0) & "00";
  stage1(1) <= "00" & stage0_out(31 downto 2);
  stage1(2) <= fill_bit & fill_bit & stage0_out(31 downto 2);
  stage1(0) <= data_in;

  mux_stage1_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel      => op,
      bus_in   => stage1,
      o_output => stage1_shifted
    );

  mux_stage1_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      i_S  => shamt(1),
      i_D0 => stage0_out,
      i_D1 => stage1_shifted,
      o_O   => stage1_out
    );

  -- ========== STAGE 2: Shift by 4 ==========
  stage2(3) <= stage1_out(27 downto 0) & "0000";
  stage2(1) <= "0000" & stage1_out(31 downto 4);
  stage2(2) <= (31 downto 28 => fill_bit) & stage1_out(31 downto 4);
  stage2(0) <= data_in;

  mux_stage2_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel      => op,
      bus_in   => stage2,
      o_output => stage2_shifted
    );

  mux_stage2_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      i_S   => shamt(2),
      i_D0  => stage1_out,
      i_D1  => stage2_shifted,
      o_O   => stage2_out
    );

  -- ========== STAGE 3: Shift by 8 ==========
  stage3(3) <= stage2_out(23 downto 0) & x"00";
  stage3(1) <= x"00" & stage2_out(31 downto 8);
  stage3(2) <= (31 downto 24 => fill_bit) & stage2_out(31 downto 8);
  stage3(0) <= data_in;

  mux_stage3_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel      => op,
      bus_in   => stage3,
      o_output => stage3_shifted
    );

  mux_stage3_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      i_S  => shamt(3),
      i_D0 => stage2_out,
      i_D1 => stage3_shifted,
      o_O  => stage3_out
    );

  -- ========== STAGE 4: Shift by 16 ==========
  stage4(3) <= stage3_out(15 downto 0) & x"0000";
  stage4(1) <= x"0000" & stage3_out(31 downto 16);
  stage4(2) <= (31 downto 16 => fill_bit) & stage3_out(31 downto 16);
  stage4(0) <= data_in;

  mux_stage4_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel      => op,
      bus_in   => stage4,
      o_output => stage4_shifted
    );

  mux_stage4_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      i_S  => shamt(4),
      i_D0 => stage3_out,
      i_D1 => stage4_shifted,
      o_O  => data_out
    );

end architecture structural;