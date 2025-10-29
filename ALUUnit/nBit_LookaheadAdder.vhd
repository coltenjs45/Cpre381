library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nBit_LookaheadAdder is
  generic(
    WIDTH : integer := 32
  );
  port(
    in_C   : in  std_logic;                                -- initial carry in
    i_A    : in  std_logic_vector(WIDTH-1 downto 0);       -- input A
    i_B    : in  std_logic_vector(WIDTH-1 downto 0);       -- input B
    o_SUM  : out std_logic_vector(WIDTH-1 downto 0);       -- sum output
    out_C  : out std_logic                                 -- carry out
  );
end nBit_LookaheadAdder;

architecture lookahead of nBit_LookaheadAdder is
  signal G, P  : std_logic_vector(WIDTH-1 downto 0);  -- generate and propagate
  signal C     : std_logic_vector(WIDTH downto 0);    -- carry signals
begin

  -- Initial carry in
  C(0) <= in_C;

  -- Generate and Propagate signals
  GEN_PROP: for i in 0 to WIDTH-1 generate
    G(i) <= i_A(i) and i_B(i);      -- generate
    P(i) <= i_A(i) xor i_B(i);      -- propagate
  end generate GEN_PROP;

  -- Carry Lookahead Logic
  CARRY_GEN: for i in 0 to WIDTH-1 generate
    C(i+1) <= G(i) or (P(i) and C(i));
  end generate CARRY_GEN;

  -- Final Sum Calculation
  SUM_GEN: for i in 0 to WIDTH-1 generate
    o_SUM(i) <= P(i) xor C(i);      -- sum bit
  end generate SUM_GEN;

  -- Final carry out
  out_C <= C(WIDTH);

end lookahead;