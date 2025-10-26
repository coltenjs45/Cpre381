library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_Reg is
  generic(WIDTH : integer := 32);
  port( CLK : in std_logic;
        RST : in std_logic;
        wEnable : in std_logic;
        inData : in std_logic_vector(WIDTH-1 downto 0);
        outData : out std_logic_vector(WIDTH-1 downto 0));
end pc_Reg;

architecture structure of pc_Reg is

  component pc_dffg
    port(i_CLK : in std_logic;
         i_RST : in std_logic;
         i_WE : in std_logic;
         i_INIT : in std_logic;
         i_D : in std_logic;
         o_Q : out std_logic);
  end component;

  constant INIT_VALUE : std_logic_vector(WIDTH-1 downto 0) := x"00400000";
  signal q_internal : std_logic_vector(WIDTH-1 downto 0);

begin

  pc_Reg: for i in 0 to WIDTH-1 generate
    pcDFFN: pc_dffg port map(
      i_CLK => CLK,
      i_RST => RST,
      i_WE => wEnable,
      i_D => inData(i),
      i_INIT => INIT_VALUE(i),
      o_Q => q_internal(i));
  end generate pc_Reg;

  outData <= q_internal;

end structure;