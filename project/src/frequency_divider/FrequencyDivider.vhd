LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FrequencyDivider IS
  GENERIC (
    -- The number of rising edges in the source clock per cycle of out clock
    out_period : POSITIVE
  );
  PORT (
    reset : IN STD_LOGIC; -- Resets when reset set high

    clk_in : IN STD_LOGIC;
    clk_out : OUT STD_LOGIC
  );
END FrequencyDivider;

ARCHITECTURE rtl OF FrequencyDivider IS
  SIGNAL clk_internal : STD_LOGIC;
  SIGNAL counter : INTEGER;
  CONSTANT N : INTEGER := 2;
BEGIN

  frequency_divider : PROCESS (reset, clk_in)
  BEGIN
    IF reset = '1' THEN
      clk_internal <= '0';
      counter <= 0;
    ELSIF rising_edge(clk_in) THEN
      IF counter = out_period/N - 1 THEN
        clk_internal <= NOT clk_internal;
        counter <= 0;
      ELSE
        counter <= counter + 1;
      END IF;
    END IF;
  END PROCESS;

  clk_out <= clk_internal;
END rtl;