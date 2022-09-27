LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

PACKAGE Vga IS

  TYPE t_VGA_SIGNALS IS RECORD
    v_sync : STD_LOGIC;
    h_sync : STD_LOGIC;
    -- gba
    -- g -> 11..8
    -- b -> 7..4
    -- a -> 3..0
    colour_output : STD_LOGIC_VECTOR(11 DOWNTO 0);
  END RECORD t_VGA_SIGNALS;

  TYPE t_POSITION IS RECORD
    x : INTEGER;
    y : INTEGER;
  END RECORD t_POSITION;

END PACKAGE;