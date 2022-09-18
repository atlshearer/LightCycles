LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Root IS
  PORT (
    clk : IN STD_LOGIC;
    vga_h_sync : OUT STD_LOGIC;
    vga_v_sync : OUT STD_LOGIC;

    vga_colour_output : OUT STD_LOGIC_VECTOR(0 TO 11);

    leds : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);

    gamepad : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    switches : IN STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE rtl OF Root IS
  SIGNAL clk_25 : STD_LOGIC;
  SIGNAL clk_second : STD_LOGIC;

  SIGNAL counter_value : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL displayReady : STD_LOGIC;

  SIGNAL pixelIndex : INTEGER;
  SIGNAL rowIndex : INTEGER;

  SIGNAL letter0fill : STD_LOGIC;
BEGIN

  -----------------------------------------------------------------------------
  -- VGA Signal generation
  clock_divider : ENTITY work.FrequencyDivider(rtl)
    GENERIC MAP(
      out_period => 2
    )
    PORT MAP(
      reset => switches(0),

      clk_in => clk,
      clk_out => clk_25
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
      clk => clk_25,
      horizonalSync => vga_h_sync,
      verticalSync => vga_v_sync,
      displayReady => displayReady,
      pixelIndex => pixelIndex,
      rowIndex => rowIndex
    );
  -----------------------------------------------------------------------------

  second_clock : ENTITY work.FrequencyDivider(rtl)
    GENERIC MAP(
      out_period => 50_000_000
    )
    PORT MAP(
      reset => switches(0),

      clk_in => clk,
      clk_out => clk_second
    );

  counter : ENTITY work.Counter(rtl)
    GENERIC MAP(
      size => 4
    )
    PORT MAP(
      reset => switches(0),
      enable => switches(1),
      clk => clk_second,

      count => counter_value
    );

  letter0 : ENTITY work.Letter0(rtl)
    PORT MAP(
      input => to_integer(unsigned(counter_value)),

      positionX => STD_LOGIC_VECTOR(to_unsigned(pixelIndex, 4))(3 DOWNTO 2),
      positionY => STD_LOGIC_VECTOR(to_unsigned(rowIndex, 4))(3 DOWNTO 2),

      fill => letter0fill
    );

  PROCESS (clk_25)
  BEGIN
    IF rising_edge(clk_25) THEN
      IF displayReady = '1' THEN
        IF STD_LOGIC_VECTOR(to_unsigned(pixelIndex, 5))(4) = '1'
          AND STD_LOGIC_VECTOR(to_unsigned(rowIndex, 5))(4) = '1'
          AND letter0fill = '1'
          THEN

          vga_colour_output <= (OTHERS => '0');
        ELSE
          vga_colour_output <= (OTHERS => '1');
        END IF;
      ELSE
        vga_colour_output <= "000000000000"; -- Blanking
      END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;