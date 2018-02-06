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
        
        input      : out std_logic_vector(31 downto 0);
		output     : in  std_logic_vector(31 downto 0)
        );
end memory_map;

architecture BHV of memory_map is
begin

	process(clk,rst)
	begin
		if (rst = '1') then
			input <= (others => '0');
			rd_data <= (others => '0');
		elsif (clk = '1' and clk'event) then
			if (wr_en = '1') then
				rd_data <= (others => '0');
				if (wr_addr = std_logic_vector(to_signed(1280,32))) then
					input <= wr_data;
				end if;
		    elsif (rd_en = '1') then
				if (rd_addr = std_logic_vector(to_signed(1280,32))) then
					rd_data <= output;
				end if;
			end if;
		end if;
	
	end process; 

end BHV;
