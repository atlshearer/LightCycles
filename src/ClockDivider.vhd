library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClockDivider is
generic (
  RisingEdgesToSwitchAfter : integer
);
port (
  Clk : in std_logic;
  ClkOut : out std_logic
);
end entity;

architecture rtl of ClockDivider is
  signal count : integer := 0;
  signal ClkInternal : std_logic := '0';
begin

  process(Clk)
  begin
    if rising_edge(Clk) then
      count <= count + 1;

      if (count = RisingEdgesToSwitchAfter - 1) then
        count <= 0;
        ClkInternal <= NOT ClkInternal;
      end if;
    end if;
  end process;

  ClkOut <= ClkInternal;

end architecture;