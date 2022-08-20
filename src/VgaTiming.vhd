library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VgaTiming is
generic (
  hVisibleArea : integer;
  hFrontPorch : integer;
  hSyncPulse : integer;
  hBackPorch : integer;

  vVisibleArea : integer;
  vFrontPorch : integer;
  vSyncPulse : integer;
  vBackPorch : integer
);
port (
  Clk : in std_logic;

  horizonalSync : out std_logic;
  verticalSync : out std_logic;

  displayReady : out std_logic;

  pixelIndex : out integer;
  rowIndex : out integer
);
end entity;

architecture rtl of VgaTiming is
  signal Pixels : integer := 0;
  signal Rows : integer := 0;
begin

  process (Clk) is
  begin
    if rising_edge(Clk) then
      Pixels <= Pixels + 1;

      if Pixels = (hVisibleArea + hFrontPorch + hSyncPulse + hBackPorch) then
        Pixels <= 0;
        Rows <= Rows + 1;
      end if;

      if Rows = (vVisibleArea + vFrontPorch + vSyncPulse + vBackPorch) then
        Rows <= 0;
      end if;
    end if;

  end process;
    
  horizonalSync <= '1' when 
    (Pixels < (hVisibleArea + hFrontPorch)) OR 
    (Pixels > (hVisibleArea + hFrontPorch + hSyncPulse)) else '0';
  verticalSync <= '1' when 
    (Rows < (vVisibleArea + vFrontPorch)) OR 
    (Rows >= (vVisibleArea + vFrontPorch + vSyncPulse)) else '0';
  displayReady <= '1' when (Pixels < hVisibleArea) AND (Rows < vVisibleArea) else '0';

  pixelIndex <= Pixels;
  rowIndex <= Rows;

end architecture;