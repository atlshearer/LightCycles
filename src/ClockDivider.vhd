LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ClockDivider IS
  GENERIC (
    RisingEdgesToSwitchAfter : INTEGER
  );
  PORT (
    Clk : IN STD_LOGIC;
    ClkOut : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE rtl OF ClockDivider IS
  SIGNAL count : INTEGER := 0;
  SIGNAL ClkInternal : STD_LOGIC := '0';
BEGIN

  PROCESS (Clk)
  BEGIN
    IF rising_edge(Clk) THEN
      count <= count + 1;

      IF (count = RisingEdgesToSwitchAfter - 1) THEN
        count <= 0;
        ClkInternal <= NOT ClkInternal;
      END IF;
    END IF;
  END PROCESS;

  ClkOut <= ClkInternal;

END ARCHITECTURE;