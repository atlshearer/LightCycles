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

  TYPE t_direction IS (Right, Down, Left, Up);
  SIGNAL direction : t_direction := Right;

  TYPE t_TurnActionState IS (Idle, LeftTurnComplete, RightTurnComplete);
  SIGNAL turnActionState : t_TurnActionState := Idle;
BEGIN

  positionX <= i_positionX;
  positionY <= i_positionY;

  PROCESS (gameClk)
  BEGIN
    IF rising_edge(gameClk) THEN
      CASE direction IS
        WHEN Right =>
          i_positionX <= i_positionX + 1;

        WHEN Down =>
          i_positionY <= i_positionY + 1;

        WHEN Left =>
          i_positionX <= i_positionX - 1;

        WHEN Up =>
          i_positionY <= i_positionY - 1;

        WHEN OTHERS =>
          NULL;
      END CASE;
    END IF;
  END PROCESS;

  PROCESS (gameClk)
  BEGIN
    IF rising_edge(gameClk) THEN
      CASE turnActionState IS
        WHEN Idle =>
          -- Turn Left
          IF leftInput = '1' AND rightInput = '0' THEN
            CASE direction IS
              WHEN Up =>
                direction <= Left;
              WHEN Down =>
                direction <= Right;
              WHEN Left =>
                direction <= Down;
              WHEN Right =>
                direction <= Up;
            END CASE;

            turnActionState <= LeftTurnComplete;
          END IF;

          -- Turn Right
          IF leftInput = '0' AND rightInput = '1' THEN
            CASE direction IS
              WHEN Up =>
                direction <= Right;
              WHEN Down =>
                direction <= Left;
              WHEN Left =>
                direction <= Up;
              WHEN Right =>
                direction <= Down;
            END CASE;

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