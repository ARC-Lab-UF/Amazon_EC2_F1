--Megan Knight

-- Greg Stitt
-- University of Florida
-- EEL 5934/4930 Reconfigurable Computing
--
-- File: fib.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fib is
  generic (width :     positive := 32);
  port( clk      : in  std_logic;
        rst      : in  std_logic;
        go       : in  std_logic;
        n        : in  std_logic_vector(width-1 downto 0);
        result   : out std_logic_vector(width-1 downto 0);
        done     : out std_logic );
end fib;

architecture FSMD_1P of fib is

  type STATE_TYPE is (START, WAIT_1, INIT, LOOP_COND,
                      LOOP_BODY, OUTPUT_RESULT);
  signal state : STATE_TYPE;

  signal n_reg   : unsigned(width-1 downto 0);
  signal i, x, y : unsigned(width-1 downto 0);
  
begin

  -- state register
  process (clk, rst)
  begin
    if (rst = '1') then
      state  <= START;
      done   <= '0';
      result <= (others => '0');
      n_reg  <= to_unsigned(0, width);
      i      <= to_unsigned(0, width);
      x      <= to_unsigned(0, width);
      y      <= to_unsigned(0, width);
     
    elsif (clk = '1' and clk'event) then

      case state is
        when START =>

          done <= '0';

          if (go = '0') then
            state <= WAIT_1;
          end if;

        when WAIT_1 =>

          if (go = '1') then
            done <= '0';
            state <= INIT;
          end if;

        when INIT =>

          n_reg <= unsigned(n);
          i     <= to_unsigned(3, width);
          x     <= to_unsigned(1, width);
          y     <= to_unsigned(1, width);

          state <= LOOP_COND;

        when LOOP_COND =>

          if (i   <= n_reg) then
            state <= LOOP_BODY;
          else
            state <= OUTPUT_RESULT;
          end if;

        when LOOP_BODY =>

          x <= y;
          y <= x+y;
          i <= i+1;

          state <= LOOP_COND;

        when OUTPUT_RESULT =>

          result <= std_logic_vector(y);
          done   <= '1';

          if (go = '0') then
            state <= WAIT_1;
          end if;

        when others => null;
      end case;

    end if;
  end process;
end FSMD_1P;



