-- Entity: memory_map
-- This entity establishes connections with user-defined addresses and
-- internal FPGA components (e.g. registers and blockRAMs).
--
-- Note: Make sure to use the addresses in user_pkg. Also, in your C code,
-- make sure to use the same constants.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity memory_map is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        wr_addr : in  std_logic_vector(31 downto 0);
        wr_data : in  std_logic_vector(31 downto 0);
        rd_en   : in  std_logic;
        rd_addr : in  std_logic_vector(31 downto 0);
        rd_data : out std_logic_vector(31 downto 0);

        -- application-specific I/O
        
        go     : out std_logic;
        n      : out std_logic_vector(31 downto 0);
        result : in  std_logic_vector(31 downto 0);
        done   : in  std_logic
        );
end memory_map;

architecture BHV of memory_map is
	
begin

	process(clk,rst)
	begin
		if (rst = '1') then
			go <= '0';
			n <= (others => '0');
			rd_data <= (others => '0');
		elsif (clk = '1' and clk'event) then
			if (wr_en = '1') then
				if (wr_addr = std_logic_vector(to_signed(0,32))) then
					go <= wr_data(0);
				elsif (wr_addr = std_logic_vector(to_signed(4,32))) then
					n <= wr_data;
				end if;
			elsif (rd_en = '1') then
				if (rd_addr = std_logic_vector(to_signed(8,32))) then
					rd_data(0) <= done;
				elsif (rd_addr = std_logic_vector(to_signed(12,32))) then
					rd_data <= result;
				end if;
			end if;
		end if;
	
	end process; 

	
end BHV;
