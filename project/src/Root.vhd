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

      colour => (OTHERS => '1')
    );
  -----------------------------------------------------------------------------

END ARCHITECTURE;