library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LightCycles is
port (
  Clock50 : in std_logic;
  vga_h_sync : out std_logic;
  vga_v_sync : out std_logic;

  vga_colour_output : out std_logic_vector(0 to 11);

  leds : out std_logic_vector(9 downto 0);

  gamepad : in std_logic_vector(5 downto 0);
  switches : in std_logic_vector(9 downto 0)
);
end entity;

architecture rtl of LightCycles is
  signal clock25 : std_logic;
  signal slowClock : std_logic;

  signal displayReady : std_logic;

  signal pixelIndex : integer;
  signal rowIndex : integer;
  signal outputColor : std_logic_vector(11 downto 0);
  signal additionalOffset : integer := 0;

  signal rowMultiplier : integer;

  signal debounced_gamepad : std_logic_vector(5 downto 0);

  signal redBikeReady : std_logic;
  signal redBikeColour : std_logic_vector(11 downto 0);
  signal blueBikeReady : std_logic;
  signal blueBikeColour : std_logic_vector(11 downto 0);
begin

  -----------------------------------------------------------------------------
  -- VGA Signal generation
  clock_divider : entity work.ClockDivider(rtl)
  generic map (
    RisingEdgesToSwitchAfter => 1
  )
  port map (
    Clk => Clock50,
    ClkOut => clock25
  );
  
  vga_timing : entity work.VgaTiming(rtl)
  generic map (
    hVisibleArea => 640,
    hFrontPorch => 16,
    hSyncPulse => 96,
    hBackPorch => 48,

    vVisibleArea => 480,
    vFrontPorch => 10,
    vSyncPulse => 2,
    vBackPorch => 33
  )
  port map (
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
  gamepad_debounder: entity work.Debouncer(rtl)
  generic map (
    switch_count => 6,
    timeout_cycles => 500_000
  )
  port map (
    clk => Clock50,
    rst => switches(1),
    switches => gamepad,
    switches_debounced => debounced_gamepad
  );
  -----------------------------------------------------------------------------

  game_clock: entity work.ClockDivider(rtl)
  generic map (
    RisingEdgesToSwitchAfter => 500_000
  )
  port map (
    Clk => Clock50,
    ClkOut => slowClock
  );

  red_bike: entity work.LightBike(rtl)
  generic map (
    BIKE_COLOUR => "111100000000"
  )
  port map (
    columnIndex => pixelIndex,
    rowIndex => rowIndex,

    gameClk => slowClock,
    pixelClk => clock25,

    moveLeft => debounced_gamepad(4),
    moveRight =>  debounced_gamepad(5),
    reset => switches(0),

    colour => redBikeColour,
    ready => redBikeReady
  );
  
  blue_bike: entity work.LightBike(rtl)
  generic map (
    BIKE_COLOUR => "000000001111"
  )
  port map (
    columnIndex => pixelIndex,
    rowIndex => rowIndex,

    gameClk => slowClock,
    pixelClk => clock25,

    moveLeft => debounced_gamepad(1),
    moveRight =>  debounced_gamepad(2),
    reset => switches(1),

    colour => blueBikeColour,
    ready => blueBikeReady
  );
  
  vga_colour_output <= 
      redBikeColour when displayReady = '1' and redBikeReady = '1' else
      blueBikeColour when displayReady = '1' and blueBikeReady = '1' else
      (others => '0');

  leds(5 downto 0) <= debounced_gamepad;
  leds(6) <= slowClock;

end architecture;