LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Player IS
  GENERIC (
    PLAY_AREA_WIDTH : POSITIVE;
    PLAY_AREA_HEIGHT : POSITIVE
  );
  PORT (
    gameClk : IN STD_LOGIC;

    positionX : OUT INTEGER RANGE 0 TO PLAY_AREA_WIDTH;
    positionY : OUT INTEGER RANGE 0 TO PLAY_AREA_HEIGHT;

    leftInput : IN STD_LOGIC;
    rightInput : IN STD_LOGIC
  );
END ENTITY;

ARCHITECTURE rtl OF Player IS
  SIGNAL i_positionX : INTEGER RANGE 0 TO PLAY_AREA_WIDTH := 10;
  SIGNAL i_positionY : INTEGER RANGE 0 TO PLAY_AREA_HEIGHT := 10;

  SIGNAL direction : INTEGER RANGE 0 TO 3;

  TYPE t_TurnActionState IS (Idle, LeftTurnComplete, RightTurnComplete);
  SIGNAL turnActionState : t_TurnActionState := Idle;

  SIGNAL i_leftX : INTEGER RANGE 0 TO PLAY_AREA_WIDTH := 10;
  SIGNAL i_rightX : INTEGER RANGE 0 TO PLAY_AREA_WIDTH := 10;
  SIGNAL i_nextX : INTEGER RANGE 0 TO PLAY_AREA_WIDTH := 10;

  SIGNAL i_upY : INTEGER RANGE 0 TO PLAY_AREA_HEIGHT := 10;
  SIGNAL i_downY : INTEGER RANGE 0 TO PLAY_AREA_HEIGHT := 10;
  SIGNAL i_nextY : INTEGER RANGE 0 TO PLAY_AREA_HEIGHT := 10;
BEGIN

  positionX <= i_positionX;
  positionY <= i_positionY;

  i_leftX <= i_positionX - 1;
  i_rightX <= i_positionX + 1;
  i_nextX <=
    i_leftX WHEN direction = 2 ELSE
    i_rightX WHEN direction = 0 ELSE
    i_positionX;

  i_upY <= i_positionY - 1;
  i_downY <= i_positionY + 1;
  i_nextY <=
    i_upY WHEN direction = 3 ELSE
    i_downY WHEN direction = 1 ELSE
    i_positionY;

  PROCESS (gameClk)
  BEGIN
    IF rising_edge(gameClk) THEN
      i_positionX <= i_nextX;
      i_positionY <= i_nextY;
    END IF;
  END PROCESS;

  PROCESS (gameClk)
  BEGIN
    IF rising_edge(gameClk) THEN
      CASE turnActionState IS
        WHEN Idle =>
          -- Turn Left
          IF leftInput = '1' AND rightInput = '0' THEN
            direction <= direction - 1;

            turnActionState <= LeftTurnComplete;
          END IF;

          -- Turn Right
          IF leftInput = '0' AND rightInput = '1' THEN
            direction <= direction + 1;

            turnActionState <= RightTurnComplete;
          END IF;

        WHEN LeftTurnComplete =>
          IF leftInput = '0' THEN
            turnActionState <= Idle;
          END IF;

        WHEN RightTurnComplete =>
          IF rightInput = '0' THEN
            turnActionState <= Idle;
          END IF;
      END CASE;
    END IF;
  END PROCESS;

END ARCHITECTURE;