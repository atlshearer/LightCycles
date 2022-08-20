library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LightBike is
generic (
  BIKE_COLOUR : std_logic_vector(11 downto 0) := "111100000000";
  SPEED : integer := 4;
  SIZE : integer := 2;
  BACK_SIZE : integer := 1
);
port (
  columnIndex : in integer;
  rowIndex : in integer;

  moveLeft : in std_logic;
  moveRight : in std_logic;
  reset : in std_logic;

  pixelClk : in std_logic;
  gameClk : in std_logic;

  colour : out std_logic_vector(11 downto 0);
  ready : out std_logic
);
end entity;

architecture rtl of LightBike is
  type t_LightBikeDirection is (Up, Down, Left, Right);
  signal lightBikeDirection : t_LightBikeDirection := Down;

  type t_TurnActionState is (Idle, LeftTurnComplete, RightTurnComplete);
  signal turnActionState : t_TurnActionState := Idle;
  
  signal currentPositionX : integer := 100;
  signal currentPositionY : integer := 100;

  signal onTrail : std_logic;

  -- signal previousX1 : integer := 100;
  -- signal previousY1 : integer := 100;
  -- signal previousX2 : integer := 100;
  -- signal previousY2 : integer := 100;
  -- signal previousX3 : integer := 100;
  -- signal previousY3 : integer := 100;
  -- signal previousX4 : integer := 100;
  -- signal previousY4 : integer := 100;
  
begin

  trail_buffer : entity work.TrailBuffer(rtl)
  generic map (
    BUFFER_LENGTH => 50
  )
  port map (
    clk => gameClk,
    readClk => pixelClk,
    write_enable => '1',
    write_row => currentPositionY,
    write_col => currentPositionX,
    rowIndex => rowIndex,
    colIndex => columnIndex,
    onTrail => onTrail
  );

  process (gameClk) is
  begin
    if rising_edge(gameClk) then
      if reset = '1' then
        currentPositionX <= 100;
        currentPositionY <= 100;
      else
        case turnActionState is
          when Idle =>
            -- Turn Left
            if moveLeft = '1' and moveRight = '0' then
              case lightBikeDirection is
                when Up =>
                  lightBikeDirection <= Left;
                when Down =>
                  lightBikeDirection <= Right;
                when Left => 
                  lightBikeDirection <= Down;
                when Right =>
                  lightBikeDirection <= Up;
              end case;

              turnActionState <= LeftTurnComplete;
            end if;

            -- Turn Right
            if moveLeft = '0' and moveRight = '1' then
              case lightBikeDirection is
                when Up =>
                  lightBikeDirection <= Right;
                when Down =>
                  lightBikeDirection <= Left;
                when Left => 
                  lightBikeDirection <= Up;
                when Right =>
                  lightBikeDirection <= Down;
              end case;

              turnActionState <= RightTurnComplete;
            end if;
          
          when LeftTurnComplete =>
            if moveLeft = '0' then
              turnActionState <= Idle;
            end if;
          
          when RightTurnComplete =>
            if moveRight = '0' then
              turnActionState <= Idle;
            end if;
        end case;

        case lightBikeDirection is
          when Up =>
            currentPositionY <= currentPositionY - SPEED;
          when Down =>
            currentPositionY <= currentPositionY + SPEED;
          when Left =>
            currentPositionX <= currentPositionX - SPEED;
          when Right =>
            currentPositionX <= currentPositionX + SPEED;
        end case;

        -- previousX1 <= currentPositionX;
        -- previousY1 <= currentPositionY;
        -- previousX2 <= previousX1;
        -- previousY2 <= previousY1;
        -- previousX3 <= previousX2;
        -- previousY3 <= previousY2;
        -- previousX4 <= previousX3;
        -- previousY4 <= previousY3;
      end if;
    end if;
  end process;

  process (pixelClk)
  begin
    if rising_edge(pixelClk) then
      if (columnIndex > currentPositionX - SIZE and columnIndex < currentPositionX + SIZE) and
        (rowIndex > currentPositionY - SIZE and rowIndex < currentPositionY + SIZE) then
          colour <= BIKE_COLOUR;
          ready <= '1';
      elsif onTrail = '1' then
        colour <= (others => '1');
        ready <= '1';
      -- elsif columnIndex = previousX1 and rowIndex = previousY1 then
      --   colour <= (others => '1');
      --   ready <= '1';
      -- elsif columnIndex = previousX2 and rowIndex = previousY2 then
      --   colour <= (others => '1');
      --   ready <= '1';
      -- elsif columnIndex = previousX3 and rowIndex = previousY3 then
      --   colour <= (others => '1');
      --   ready <= '1';
      -- elsif columnIndex = previousX4 and rowIndex = previousY4 then
      --   colour <= (others => '1');
      --   ready <= '1';
      else
        case lightBikeDirection is
          when Up =>
            if (columnIndex > currentPositionX - BACK_SIZE and columnIndex < currentPositionX + BACK_SIZE) and
              (rowIndex >= currentPositionY + SIZE and rowIndex < currentPositionY + 3 * SIZE) then
                colour <= (others => '1');
                ready <= '1';
              else
                ready <= '0';
            end if;
          when Down =>
            if (columnIndex > currentPositionX - BACK_SIZE and columnIndex < currentPositionX + BACK_SIZE) and
              (rowIndex > currentPositionY - 3 * SIZE and rowIndex <= currentPositionY - SIZE) then
                colour <= (others => '1');
                ready <= '1';
              else
                ready <= '0';
            end if;
          when Left =>
            if (columnIndex >= currentPositionX + SIZE and columnIndex < currentPositionX + 3 * SIZE) and
              (rowIndex > currentPositionY - BACK_SIZE and rowIndex < currentPositionY + BACK_SIZE) then
                colour <= (others => '1');
                ready <= '1';
              else
                ready <= '0';
            end if;
          when Right =>
            if (columnIndex > currentPositionX - 3 * SIZE and columnIndex <= currentPositionX - SIZE) and
              (rowIndex > currentPositionY - BACK_SIZE and rowIndex < currentPositionY + BACK_SIZE) then
                colour <= (others => '1');
                ready <= '1';
              else
                ready <= '0';
            end if;
        end case;
      end if;

    end if;
  end process;
end architecture;