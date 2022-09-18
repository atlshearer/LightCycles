LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Letter0 IS
  PORT (
    input : IN INTEGER RANGE 0 TO 15;
    positionX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    positionY : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

    fill : OUT STD_LOGIC -- indicates if the current pixel should be filled    
  );
END ENTITY;

ARCHITECTURE rtl OF Letter0 IS
  CONSTANT zero : STD_LOGIC_VECTOR(0 TO 15) := "0110101111010110";
  CONSTANT one : STD_LOGIC_VECTOR(0 TO 15) := "0100010001000100";
  CONSTANT two : STD_LOGIC_VECTOR(0 TO 15) := "1100001001001110";
  CONSTANT three : STD_LOGIC_VECTOR(0 TO 15) := "1100011000101100";
  CONSTANT four : STD_LOGIC_VECTOR(0 TO 15) := "1001100111110001";
  CONSTANT five : STD_LOGIC_VECTOR(0 TO 15) := "1111111000011110";
  CONSTANT six : STD_LOGIC_VECTOR(0 TO 15) := "1000111010010110";
  CONSTANT seven : STD_LOGIC_VECTOR(0 TO 15) := "1111100100010001";
  CONSTANT eight : STD_LOGIC_VECTOR(0 TO 15) := "0110111110010110";
  CONSTANT nine : STD_LOGIC_VECTOR(0 TO 15) := "0110100101110001";
  CONSTANT a : STD_LOGIC_VECTOR(0 TO 15) := "0000011110010111";
  CONSTANT b : STD_LOGIC_VECTOR(0 TO 15) := "1000111010011110";
  CONSTANT c : STD_LOGIC_VECTOR(0 TO 15) := "0000011110000111";
  CONSTANT d : STD_LOGIC_VECTOR(0 TO 15) := "0001011110010111";
  CONSTANT e : STD_LOGIC_VECTOR(0 TO 15) := "0000011011110111";
  CONSTANT f : STD_LOGIC_VECTOR(0 TO 15) := "0110010011100100";

BEGIN

  PROCESS (input, positionX, positionY)
    VARIABLE selection : INTEGER;
  BEGIN

    selection := to_integer(unsigned(positionY & positionX));

    CASE input IS
      WHEN 0 =>
        fill <= zero(selection);
      WHEN 1 =>
        fill <= one(selection);
      WHEN 2 =>
        fill <= two(selection);
      WHEN 3 =>
        fill <= three(selection);
      WHEN 4 =>
        fill <= four(selection);
      WHEN 5 =>
        fill <= five(selection);
      WHEN 6 =>
        fill <= six(selection);
      WHEN 7 =>
        fill <= seven(selection);
      WHEN 8 =>
        fill <= eight(selection);
      WHEN 9 =>
        fill <= nine(selection);
      WHEN 10 =>
        fill <= a(selection);
      WHEN 11 =>
        fill <= b(selection);
      WHEN 12 =>
        fill <= c(selection);
      WHEN 13 =>
        fill <= d(selection);
      WHEN 14 =>
        fill <= e(selection);
      WHEN 15 =>
        fill <= f(selection);
    END CASE;

  END PROCESS;

END ARCHITECTURE;