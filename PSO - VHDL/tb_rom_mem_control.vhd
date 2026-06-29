library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom_mem_control is
end tb_rom_mem_control;


architecture behavior of tb_rom_mem_control is

	component ROM_MEM_CONTROL
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
	
	end component;
	
	constant T: time := 20 ps;
	constant ADDR_WIDTH: integer :=8;
	constant NUM_SAMPLES: natural := 200;
	
	signal CLK: std_logic := '0';
	signal RESET: std_logic :='0';
	signal ADDR: std_logic_vector((ADDR_WIDTH-1) downto 0);
	signal FINISH: std_logic := '0';
	
	
	signal sim_active : boolean := true;
	
	
	
begin	
	
	L0: ROM_MEM_CONTROL generic map(ADDR_WIDTH, NUM_SAMPLES) port map(CLK, RESET, ADDR, FINISH);
							  
	process
	begin
		while sim_active loop
			CLK <= '0';
			wait for T/2;
			CLK <= '1';
			wait for T/2;
		end loop;
		wait;
	end process;
	
	process
	begin
		RESET <= '0';
		wait for 2*T;
		
		RESET <= '1';
		
		wait until FINISH = '1';
		
		wait for 2*T;
		
		RESET <= '0';
		wait for T;
		
		RESET <= '1';
		wait for 2*T;
		
		sim_active <= false;
		wait for 4*T;
	
		assert false report "simulation completed" severity failure;
		
	end process;
	

end behavior; 
