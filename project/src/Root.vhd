LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.vga.ALL;

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

  SIGNAL vga_signals : t_VGA_SIGNALS;
  SIGNAL current_pixel : t_POSITION;
  SIGNAL restricted_pixel : t_POSITION;

  SIGNAL colour : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL fill : STD_LOGIC;
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

  vga_h_sync <= vga_signals.h_sync;
  vga_v_sync <= vga_signals.v_sync;
  vga_colour_output <= vga_signals.colour_output;

  vga_timing : ENTITY work.VgaTiming(rtl)
    PORT MAP(
      clk => clk_25,

      vga_signals => vga_signals,
      current_pixel => current_pixel,

      colour => colour
    );
  -----------------------------------------------------------------------------\

  letter_restriction : ENTITY work.RestrictedView(rtl)
    GENERIC MAP(
      top_left => (x => 100, y => 100),
      bottom_right => (x => 116, y => 116)
    )
    PORT MAP(
      current_pixel => current_pixel,
      restricted_pixel => restricted_pixel,
      primary_colour => (OTHERS => fill),
      secondary_colour => "000000000000",
      output_colour => colour
    );

  letter0 : ENTITY work.Letter0(rtl)
    PORT MAP(
      input => to_integer(unsigned(switches(9 DOWNTO 6))),

      positionX => STD_LOGIC_VECTOR(to_unsigned(restricted_pixel.x, 4))(3 DOWNTO 2),
      positionY => STD_LOGIC_VECTOR(to_unsigned(restricted_pixel.y, 4))(3 DOWNTO 2),

      fill => fill
    );
END ARCHITECTURE;