library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ROM_MEM_CONTROL is
	generic(
		ADDR_WIDTH: integer := 8;
		NUM_SAMPLES: natural := 200
		);

	port(
		CLK: in std_logic;
		RESET: in std_logic;
		ADDR: out std_logic_vector((ADDR_WIDTH-1) downto 0);
		FINISH: out std_logic
		);

end ROM_MEM_CONTROL;

architecture behavior of ROM_MEM_CONTROL is
	
	signal s_cont: natural range 0 to NUM_SAMPLES := 0;
	signal s_finish: std_logic := '0';
	

begin
	
	process(CLK, RESET)
	begin
	
		if(RESET = '0') then
			s_cont <= 0;
			s_finish <= '0';
			
		elsif(falling_edge(CLK)) then 
			if(s_finish = '0') then
				
				ADDR <= std_logic_vector(to_unsigned(s_cont, ADDR_WIDTH));
				
				if(s_cont < NUM_SAMPLES-1) then
					s_cont <= s_cont + 1;
				else
					s_finish <= '1';
				
				end if;
			end if;
		end if;
			
	end process;
	FINISH<= s_finish;
	
end behavior; 


