LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

USE work.vga.ALL;

ENTITY RestrictedView IS
  GENERIC (
    -- Position of the top left corner
    top_left : t_POSITION;
    -- Width and height of the view
    bottom_right : t_POSITION
  );
  PORT (
    current_pixel : IN t_POSITION;
    restricted_pixel : OUT t_POSITION;

    primary_colour : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    secondary_colour : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

    output_colour : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
END ENTITY RestrictedView;

ARCHITECTURE rtl OF RestrictedView IS

BEGIN

  PROCESS (current_pixel)
    VARIABLE isInRect : BOOLEAN;
  BEGIN

    isInRect := (current_pixel.x > top_left.x) AND (current_pixel.x < bottom_right.x) AND
      (current_pixel.y > top_left.y) AND (current_pixel.y < bottom_right.y);

    IF isInRect THEN
      restricted_pixel <= (
        x => current_pixel.x - top_left.x,
        y => current_pixel.y - top_left.y);
      output_colour <= primary_colour;
    ELSE
      restricted_pixel <= (x => 0, y => 0);
      output_colour <= secondary_colour;
    END IF;

  END PROCESS;
END ARCHITECTURE;