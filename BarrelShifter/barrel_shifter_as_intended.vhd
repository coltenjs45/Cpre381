library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2x1 is
  generic (WIDTH : positive := 32);
  port (
    sel : in  std_logic;
    a   : in  std_logic_vector(WIDTH-1 downto 0);
    b   : in  std_logic_vector(WIDTH-1 downto 0);
    y   : out std_logic_vector(WIDTH-1 downto 0)
  );
end entity mux2x1;

architecture rtl of mux2x1 is
begin
  y <= a when sel = '0' else b;
end architecture rtl;

entity mux4x1 is
  generic (WIDTH : positive := 32);
  port (
    sel : in  std_logic_vector(1 downto 0);
    a   : in  std_logic_vector(WIDTH-1 downto 0);
    b   : in  std_logic_vector(WIDTH-1 downto 0);
    c   : in  std_logic_vector(WIDTH-1 downto 0);
    y   : out std_logic_vector(WIDTH-1 downto 0)
  );
end entity mux4x1;

architecture rtl of mux4x1 is
begin
  y <= a when sel = "00" else
       b when sel = "01" else
       c when sel = "10" else
       c;
end architecture rtl;

entity barrel_shifter_32bit is
  port (
    data_in  : in  std_logic_vector(31 downto 0);
    shamt    : in  std_logic_vector(4 downto 0);
    op       : in  std_logic_vector(1 downto 0);
    data_out : out std_logic_vector(31 downto 0)
  );
end entity barrel_shifter_32bit;

architecture structural of barrel_shifter_32bit is

  -- Stage 0 signals (shift by 1)
  signal stage0_sll, stage0_srl, stage0_sra : std_logic_vector(31 downto 0);
  signal stage0_shifted : std_logic_vector(31 downto 0);
  signal stage0_out : std_logic_vector(31 downto 0);

  -- Stage 1 signals (shift by 2)
  signal stage1_sll, stage1_srl, stage1_sra : std_logic_vector(31 downto 0);
  signal stage1_shifted : std_logic_vector(31 downto 0);
  signal stage1_out : std_logic_vector(31 downto 0);

  -- Stage 2 signals (shift by 4)
  signal stage2_sll, stage2_srl, stage2_sra : std_logic_vector(31 downto 0);
  signal stage2_shifted : std_logic_vector(31 downto 0);
  signal stage2_out : std_logic_vector(31 downto 0);

  -- Stage 3 signals (shift by 8)
  signal stage3_sll, stage3_srl, stage3_sra : std_logic_vector(31 downto 0);
  signal stage3_shifted : std_logic_vector(31 downto 0);
  signal stage3_out : std_logic_vector(31 downto 0);

  -- Stage 4 signals (shift by 16)
  signal stage4_sll, stage4_srl, stage4_sra : std_logic_vector(31 downto 0);
  signal stage4_shifted : std_logic_vector(31 downto 0);

  -- Fill bit
  signal fill_bit : std_logic;

  component mux2x1
    generic (WIDTH : positive := 32);
    port (
      sel : in  std_logic;
      a   : in  std_logic_vector(WIDTH-1 downto 0);
      b   : in  std_logic_vector(WIDTH-1 downto 0);
      y   : out std_logic_vector(WIDTH-1 downto 0)
    );
  end component mux2x1;

  component mux4x1
    generic (WIDTH : positive := 32);
    port (
      sel : in  std_logic_vector(1 downto 0);
      a   : in  std_logic_vector(WIDTH-1 downto 0);
      b   : in  std_logic_vector(WIDTH-1 downto 0);
      c   : in  std_logic_vector(WIDTH-1 downto 0);
      y   : out std_logic_vector(WIDTH-1 downto 0)
    );
  end component mux4x1;

begin

  fill_bit <= data_in(31);

  -- ========== STAGE 0: Shift by 1 ==========
  stage0_sll <= data_in(30 downto 0) & '0';
  stage0_srl <= '0' & data_in(31 downto 1);
  stage0_sra <= fill_bit & data_in(31 downto 1);

  mux_stage0_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel => op,
      a   => stage0_sll,
      b   => stage0_srl,
      c   => stage0_sra,
      y   => stage0_shifted
    );

  mux_stage0_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      sel => shamt(0),
      a   => data_in,
      b   => stage0_shifted,
      y   => stage0_out
    );

  -- ========== STAGE 1: Shift by 2 ==========
  stage1_sll <= stage0_out(29 downto 0) & "00";
  stage1_srl <= "00" & stage0_out(31 downto 2);
  stage1_sra <= fill_bit & fill_bit & stage0_out(31 downto 2);

  mux_stage1_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel => op,
      a   => stage1_sll,
      b   => stage1_srl,
      c   => stage1_sra,
      y   => stage1_shifted
    );

  mux_stage1_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      sel => shamt(1),
      a   => stage0_out,
      b   => stage1_shifted,
      y   => stage1_out
    );

  -- ========== STAGE 2: Shift by 4 ==========
  stage2_sll <= stage1_out(27 downto 0) & "0000";
  stage2_srl <= "0000" & stage1_out(31 downto 4);
  stage2_sra <= (31 downto 28 => fill_bit) & stage1_out(31 downto 4);

  mux_stage2_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel => op,
      a   => stage2_sll,
      b   => stage2_srl,
      c   => stage2_sra,
      y   => stage2_shifted
    );

  mux_stage2_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      sel => shamt(2),
      a   => stage1_out,
      b   => stage2_shifted,
      y   => stage2_out
    );

  -- ========== STAGE 3: Shift by 8 ==========
  stage3_sll <= stage2_out(23 downto 0) & x"00";
  stage3_srl <= x"00" & stage2_out(31 downto 8);
  stage3_sra <= (31 downto 24 => fill_bit) & stage2_out(31 downto 8);

  mux_stage3_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel => op,
      a   => stage3_sll,
      b   => stage3_srl,
      c   => stage3_sra,
      y   => stage3_shifted
    );

  mux_stage3_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      sel => shamt(3),
      a   => stage2_out,
      b   => stage3_shifted,
      y   => stage3_out
    );

  -- ========== STAGE 4: Shift by 16 ==========
  stage4_sll <= stage3_out(15 downto 0) & x"0000";
  stage4_srl <= x"0000" & stage3_out(31 downto 16);
  stage4_sra <= (31 downto 16 => fill_bit) & stage3_out(31 downto 16);

  mux_stage4_op : mux4x1
    generic map (WIDTH => 32)
    port map (
      sel => op,
      a   => stage4_sll,
      b   => stage4_srl,
      c   => stage4_sra,
      y   => stage4_shifted
    );

  mux_stage4_shamt : mux2x1
    generic map (WIDTH => 32)
    port map (
      sel => shamt(4),
      a   => stage3_out,
      b   => stage4_shifted,
      y   => data_out
    );

end architecture structural;