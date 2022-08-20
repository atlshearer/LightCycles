library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity TrailBuffer is
generic (
  BUFFER_LENGTH : positive := 10
);
port (
  clk : in std_logic;
  readClk : in std_logic;
  -- rst : in std_logic;

  write_enable : in std_logic;
  write_row : in integer;
  write_col : in integer;

  rowIndex : in integer;
  colIndex : in integer;
  onTrail : out std_logic
);
end entity;

architecture rtl of TrailBuffer is
  type ram_type is array (0 to BUFFER_LENGTH - 1) of integer;
  signal ram_row : ram_type;
  signal ram_col : ram_type;

  subtype index_type is integer range ram_type'range;
  signal head : index_type;

  procedure incrementAndWrap (signal index : inout index_type) is
  begin
    if index = index_type'high then
      index <= index_type'low;
    else
      index <= index + 1;
    end if;
  end procedure;
begin

  process (clk)
  begin
    if rising_edge(clk) then
      if write_enable = '1' then
        incrementAndWrap(head);
        ram_row(head) <= write_row;
        ram_col(head) <= write_col;
      end if;
    end if;
  end process;

  process (readClk)
  begin
    if rising_edge(readClk) then
      onTrail <= '0';

      for i in ram_type'low to ram_type'high loop
        if ram_row(i) = rowIndex and ram_col(i) = colIndex then
          onTrail <= '1';
        end if;
      end loop;
    end if;
  end process;

end architecture;