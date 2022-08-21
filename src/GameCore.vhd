LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.Game.ALL;

ENTITY GameCore IS
  GENERIC (
    PLAY_AREA_WIDTH : POSITIVE := 100;
    PLAY_AREA_HEIGHT : POSITIVE := 100
  );
  PORT (
    clk : IN STD_LOGIC;

    -- Bring high to reset game state
    reset : IN STD_LOGIC;

    player2Inputs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

    xRead : IN INTEGER RANGE 0 TO PLAY_AREA_WIDTH - 1;
    yRead : IN INTEGER RANGE 0 TO PLAY_AREA_HEIGHT - 1;
    locationState : OUT t_LocationState
  );
END ENTITY;

ARCHITECTURE rtl OF GameCore IS
  SIGNAL positionX : INTEGER;
  SIGNAL positionY : INTEGER;

  SIGNAL gameTick : STD_LOGIC;
BEGIN

  game_tick : ENTITY work.GameTick(rtl)
    GENERIC MAP(
      RisingEdgesPerGameTick => 5_000_000
    )
    PORT MAP(
      clk => clk,
      gameTick => gameTick
    );

  game_memory : ENTITY work.GameMemory(rtl)
    GENERIC MAP(
      PLAY_AREA_WIDTH => PLAY_AREA_WIDTH,
      PLAY_AREA_HEIGHT => PLAY_AREA_HEIGHT
    )
    PORT MAP(
      clk => clk,

      xWrite => positionX,
      yWrite => positionY,
      writeState => Path,

      xRead => xRead,
      yRead => yRead,
      locationState => locationState
    );

  player_2 : ENTITY work.Player(rtl)
    GENERIC MAP(
      PLAY_AREA_WIDTH => PLAY_AREA_WIDTH,
      PLAY_AREA_HEIGHT => PLAY_AREA_HEIGHT
    )
    PORT MAP(
      gameClk => gameTick,

      positionX => positionX,
      positionY => positionY,

      leftInput => player2Inputs(1),
      rightInput => player2Inputs(2)
    );

END ARCHITECTURE;