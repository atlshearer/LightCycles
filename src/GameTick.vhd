LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY GameTick IS
  GENERIC (
    RisingEdgesPerGameTick : INTEGER
  );
  PORT (
    clk : IN STD_LOGIC;
    gameTick : OUT STD_LOGIC
  );
END ENTITY;

ARCHITECTURE rtl OF GameTick IS
  SIGNAL count : INTEGER RANGE 0 TO RisingEdgesPerGameTick;

BEGIN

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      count <= count + 1;
      gameTick <= '0';

      IF count = RisingEdgesPerGameTick - 1 THEN
        count <= 0;
        gameTick <= '1';
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;