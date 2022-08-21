LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Debouncer IS
  GENERIC (
    switch_count : POSITIVE;
    timeout_cycles : POSITIVE
  );
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    switches : IN STD_LOGIC_VECTOR(switch_count - 1 DOWNTO 0);
    switches_debounced : OUT STD_LOGIC_VECTOR(switch_count - 1 DOWNTO 0)
  );
END Debouncer;

ARCHITECTURE rtl OF Debouncer IS
BEGIN

  MY_GEN : FOR i IN 0 TO switch_count - 1 GENERATE

    SIGNAL debounced : STD_LOGIC;
    SIGNAL counter : INTEGER RANGE 0 TO timeout_cycles - 1;

  BEGIN

    switches_debounced(i) <= debounced;

    DEBOUNCE_PROC : PROCESS (clk)
    BEGIN
      IF rising_edge(clk) THEN
        IF rst = '1' THEN
          counter <= 0;
          debounced <= switches(i);

        ELSE

          IF counter < timeout_cycles - 1 THEN
            counter <= counter + 1;
          ELSIF switches(i) /= debounced THEN
            counter <= 0;
            debounced <= switches(i);
          END IF;

        END IF;
      END IF;
    END PROCESS;

  END GENERATE;

END ARCHITECTURE;