LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

ENTITY TFlipFlop IS
  PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;

    t : IN STD_LOGIC;
    q : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE rtl OF TFlipFlop IS
  SIGNAL q_internal : STD_LOGIC;
BEGIN

  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      q_internal <= '0';
    ELSIF rising_edge(clk) THEN
      IF t = '1' THEN
        q_internal <= NOT q_internal;
      END IF;
    END IF;
  END PROCESS;

  q <= q_internal;

END ARCHITECTURE;