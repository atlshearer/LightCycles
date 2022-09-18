LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Counter IS
  GENERIC (
    size : POSITIVE
  );
  PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    enable : IN STD_LOGIC;

    count : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
  );
END ENTITY Counter;

ARCHITECTURE rtl OF Counter IS
  SIGNAL t : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
  SIGNAL q : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
BEGIN

  gen_t_flip_flop : FOR i IN 0 TO size - 1 GENERATE

    t_flip_flop : ENTITY work.TFlipFlop(rtl)
      PORT MAP(
        clk => clk,
        reset => reset,
        t => t(i),
        q => q(i)
      );

  END GENERATE;

  gen_and : FOR i IN 1 TO size - 1 GENERATE

    t(i) <= t(i - 1) AND q(i - 1);

  END GENERATE;

  t(0) <= enable;
  count <= q;

END ARCHITECTURE;