LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.Game.ALL;

ENTITY GameMemory IS
  GENERIC (
    PLAY_AREA_WIDTH : POSITIVE;
    PLAY_AREA_HEIGHT : POSITIVE
  );
  PORT (
    clk : IN STD_LOGIC;

    -- Write signals
    xWrite : IN INTEGER RANGE 0 TO PLAY_AREA_WIDTH;
    yWrite : IN INTEGER RANGE 0 TO PLAY_AREA_HEIGHT;
    writeState : IN t_LocationState;

    -- Read signals
    xRead : IN INTEGER RANGE 0 TO PLAY_AREA_WIDTH;
    yRead : IN INTEGER RANGE 0 TO PLAY_AREA_HEIGHT;
    locationState : OUT t_LocationState
  );
END ENTITY;

ARCHITECTURE rtl OF GameMemory IS
  TYPE t_GameArea IS ARRAY (0 TO PLAY_AREA_WIDTH - 1, 0 TO PLAY_AREA_HEIGHT - 1) OF STD_LOGIC;
  SIGNAL gameArea : t_GameArea := (OTHERS => (OTHERS => '0'));

  SIGNAL i_writeState : STD_LOGIC;
  SIGNAL i_locationState : STD_LOGIC;
BEGIN

  i_writeState <= '1'
    WHEN writeState = Path ELSE
    '0';

  locationState <= Path
    WHEN i_locationState = '1' ELSE
    Empty;

  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      gameArea(xWrite, yWrite) <= i_writeState;
      i_locationState <= gameArea(xRead, yRead);
    END IF;
  END PROCESS;

END ARCHITECTURE;