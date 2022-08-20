library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
  generic (
    switch_count : positive;
    timeout_cycles : positive
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    switches : in std_logic_vector(switch_count - 1 downto 0);
    switches_debounced : out std_logic_vector(switch_count - 1 downto 0)
  );
end Debouncer;

architecture rtl of Debouncer is
begin
 
  MY_GEN : for i in 0 to switch_count - 1 generate
 
    signal debounced : std_logic;
    signal counter : integer range 0 to timeout_cycles - 1;
 
  begin
 
    switches_debounced(i) <= debounced;
 
    DEBOUNCE_PROC : process(clk)
    begin
      if rising_edge(clk) then
        if rst = '1' then
          counter <= 0;
          debounced <= switches(i);
 
        else
 
          if counter < timeout_cycles - 1 then
            counter <= counter + 1;
          elsif switches(i) /= debounced then
            counter <= 0;
            debounced <= switches(i);
          end if;
 
        end if;
      end if;
    end process;
 
  end generate;
 
end architecture;
