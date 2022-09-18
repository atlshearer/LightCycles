LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY VgaTiming IS
  GENERIC (
    hVisibleArea : INTEGER;
    hFrontPorch : INTEGER;
    hSyncPulse : INTEGER;
    hBackPorch : INTEGER;

    vVisibleArea : INTEGER;
    vFrontPorch : INTEGER;
    vSyncPulse : INTEGER;
    vBackPorch : INTEGER
  );
  PORT (
    Clk : IN STD_LOGIC;

    horizonalSync : OUT STD_LOGIC;
    verticalSync : OUT STD_LOGIC;

    displayReady : OUT STD_LOGIC;

    pixelIndex : OUT INTEGER;
    rowIndex : OUT INTEGER
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

  horizonalSync <= '1' WHEN
    (Pixels < (hVisibleArea + hFrontPorch)) OR
    (Pixels > (hVisibleArea + hFrontPorch + hSyncPulse)) ELSE
    '0';
  verticalSync <= '1' WHEN
    (Rows < (vVisibleArea + vFrontPorch)) OR
    (Rows >= (vVisibleArea + vFrontPorch + vSyncPulse)) ELSE
    '0';
  displayReady <= '1' WHEN (Pixels < hVisibleArea) AND (Rows < vVisibleArea) ELSE
    '0';

  pixelIndex <= Pixels;
  rowIndex <= Rows;

END ARCHITECTURE;