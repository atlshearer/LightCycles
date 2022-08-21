LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Game.ALL;

ENTITY LightCycles IS
  PORT (
    Clock50 : IN STD_LOGIC;
    vga_h_sync : OUT STD_LOGIC;
    vga_v_sync : OUT STD_LOGIC;

    vga_colour_output : OUT STD_LOGIC_VECTOR(0 TO 11);

    leds : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);

    gamepad : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    switches : IN STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE rtl OF LightCycles IS
  SIGNAL clock25 : STD_LOGIC;

  SIGNAL displayReady : STD_LOGIC;

  SIGNAL pixelIndex : INTEGER;
  SIGNAL rowIndex : INTEGER;

  SIGNAL debounced_gamepad : STD_LOGIC_VECTOR(5 DOWNTO 0);

  SIGNAL gameX : INTEGER RANGE 0 TO 100;
  SIGNAL gameY : INTEGER RANGE 0 TO 100;
  SIGNAL locationState : t_LocationState;
BEGIN

  -----------------------------------------------------------------------------
  -- VGA Signal generation
  clock_divider : ENTITY work.ClockDivider(rtl)
    GENERIC MAP(
      RisingEdgesToSwitchAfter => 1
    )
    PORT MAP(
      Clk => Clock50,
      ClkOut => clock25
    );

  vga_timing : ENTITY work.VgaTiming(rtl)
    GENERIC MAP(
      hVisibleArea => 640,
      hFrontPorch => 16,
      hSyncPulse => 96,
      hBackPorch => 48,

      vVisibleArea => 480,
      vFrontPorch => 10,
      vSyncPulse => 2,
      vBackPorch => 33
    )
    PORT MAP(
      Clk => Clock25,
      horizonalSync => vga_h_sync,
      verticalSync => vga_v_sync,
      displayReady => displayReady,
      pixelIndex => pixelIndex,
      rowIndex => rowIndex
    );
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Input debounce
  gamepad_debounder : ENTITY work.Debouncer(rtl)
    GENERIC MAP(
      switch_count => 6,
      timeout_cycles => 500_000
    )
    PORT MAP(
      clk => Clock50,
      rst => switches(1),
      switches => gamepad,
      switches_debounced => debounced_gamepad
    );
  -----------------------------------------------------------------------------

  gameX <= to_integer(unsigned(STD_LOGIC_VECTOR(to_unsigned(pixelIndex, 9))(8 DOWNTO 2)))
    WHEN pixelIndex < 400 ELSE
    0;
  gameY <= to_integer(unsigned(STD_LOGIC_VECTOR(to_unsigned(rowIndex, 9))(8 DOWNTO 2)))
    WHEN rowIndex < 400 ELSE
    0;

  game_core : ENTITY work.GameCore(rtl)
    PORT MAP(
      clk => Clock50,

      reset => debounced_gamepad(0),

      player2Inputs => debounced_gamepad(5 DOWNTO 3),

      xRead => gameX,
      yRead => gameY,
      locationState => locationState
    );

  PROCESS (clock25)
  BEGIN
    IF rising_edge(clock25) THEN
      IF displayReady = '1' THEN
        IF pixelIndex < 400 AND rowIndex < 400 THEN
          CASE locationState IS
            WHEN Empty =>
              vga_colour_output <= "000000000000";

            WHEN Path =>
              vga_colour_output <= "111111111111";

            WHEN OTHERS =>
              vga_colour_output <= "000000000000";
          END CASE;
        ELSE
          vga_colour_output <= "111100000000";
        END IF;
      ELSE
        vga_colour_output <= "000000000000";
      END IF;
    END IF;
  END PROCESS;

  leds(5 DOWNTO 0) <= debounced_gamepad;

END ARCHITECTURE;