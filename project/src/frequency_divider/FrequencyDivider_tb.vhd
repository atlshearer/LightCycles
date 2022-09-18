LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FrequencyDivider_tb IS
END ENTITY FrequencyDivider_tb;

ARCHITECTURE rtl OF FrequencyDivider_tb IS

  CONSTANT HALF_PERIOD : TIME := 10 ns;

  SIGNAL clk : STD_LOGIC;
  SIGNAL reset : STD_LOGIC;

  SIGNAL clk_4_hz : STD_LOGIC;
  SIGNAL clk_6_hz : STD_LOGIC;

  PROCEDURE checkClock (SIGNAL clk : IN STD_LOGIC; CONSTANT expected : IN STD_LOGIC) IS
  BEGIN
    ASSERT clk = expected
    REPORT "clk did not match expected value ("
      & STD_LOGIC'image(clk) & " != "
      & STD_LOGIC'image(expected) & ")"
      SEVERITY error;

  END PROCEDURE;

BEGIN

  frequency_divider_0 : ENTITY work.FrequencyDivider(Behav)
    GENERIC MAP(
      out_period => 4
    )
    PORT MAP(
      clk_in => clk,
      reset => reset,
      clk_out => clk_4_hz
    );

  test_process_0 : PROCESS
  BEGIN

    -- Initlialise

    clk <= '0';
    reset <= '1';
    WAIT FOR HALF_PERIOD;

    reset <= '0';
    WAIT FOR HALF_PERIOD;

    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_4_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_4_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_4_hz, '0');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_4_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_4_hz, '0');

  END PROCESS;

  frequency_divider_1 : ENTITY work.FrequencyDivider(Behav)
    GENERIC MAP(
      Out_period => 6
    )
    PORT MAP(
      clk_in => clk,
      reset => reset,
      clk_out => clk_6_hz
    );

  test_process_1 : PROCESS
  BEGIN

    -- Initlialise

    clk <= '0';
    reset <= '1';
    WAIT FOR HALF_PERIOD;

    reset <= '0';
    WAIT FOR HALF_PERIOD;

    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '0');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '0');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '0');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '1');

    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    clk <= '0';
    WAIT FOR HALF_PERIOD;
    clk <= '1';
    WAIT FOR HALF_PERIOD;
    checkClock(clk_6_hz, '0');

  END PROCESS;
END ARCHITECTURE;