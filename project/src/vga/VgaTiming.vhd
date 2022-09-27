LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.vga.ALL;

ENTITY VgaTiming IS
  GENERIC (
    hVisibleArea : INTEGER := 640;
    hFrontPorch : INTEGER := 16;
    hSyncPulse : INTEGER := 96;
    hBackPorch : INTEGER := 48;

    vVisibleArea : INTEGER := 480;
    vFrontPorch : INTEGER := 10;
    vSyncPulse : INTEGER := 2;
    vBackPorch : INTEGER := 33
  );
  PORT (
    clk : IN STD_LOGIC;

    vga_signals : OUT t_VGA_SIGNALS;

    current_pixel : OUT t_POSITION;
    colour : IN STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE rtl OF VgaTiming IS
  SIGNAL Pixels : INTEGER := 0;
  SIGNAL Rows : INTEGER := 0;
BEGIN

  PROCESS (Clk) IS
  BEGIN
    IF rising_edge(Clk) THEN
      Pixels <= Pixels + 1;

      IF Pixels = (hVisibleArea + hFrontPorch + hSyncPulse + hBackPorch) THEN
        Pixels <= 0;
        Rows <= Rows + 1;
      END IF;

      IF Rows = (vVisibleArea + vFrontPorch + vSyncPulse + vBackPorch) THEN
        Rows <= 0;
      END IF;
    END IF;

  END PROCESS;

  vga_signals.h_sync <= '1' WHEN
  (Pixels < (hVisibleArea + hFrontPorch)) OR
  (Pixels > (hVisibleArea + hFrontPorch + hSyncPulse)) ELSE
  '0';
  vga_signals.v_sync <= '1' WHEN
  (Rows < (vVisibleArea + vFrontPorch)) OR
  (Rows >= (vVisibleArea + vFrontPorch + vSyncPulse)) ELSE
  '0';

  p_OUTPUT_COLOUR : PROCESS (Pixels, Rows) IS
  BEGIN
    IF (Pixels < hVisibleArea) AND (Rows < vVisibleArea) THEN
      vga_signals.colour_output <= colour;
    ELSE
      vga_signals.colour_output <= (OTHERS => '0');
    END IF;
  END PROCESS;

  current_pixel.x <= Pixels;
  current_pixel.y <= Rows;
END ARCHITECTURE;