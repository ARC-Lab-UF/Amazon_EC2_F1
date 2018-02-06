library ieee;
use ieee.std_logic_1164.all;


entity hello_world_code is
    port (
        
        -- memory-map interface
        
        input : in  std_logic_vector(31 downto 0);
        output : out  std_logic_vector(31 downto 0)
        
        );
end hello_world_code;

architecture default of hello_world_code is
begin

	output <= input(7 downto 0)&input(15 downto 8)&input(23 downto 16)&input(31 downto 24);

end default;