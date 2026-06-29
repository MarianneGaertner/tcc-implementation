library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity DATA_MEMORY is
	
	generic(
		ADDR_WIDTH: integer := 8;
		DATA_WIDTH  : integer := 32;
		NUM_SAMPLES: natural := 200;
		X_FILE_NAME: string  := "C:/Users/maria/OneDrive/Documents/TCC/dados_simulacao_4_x.mif";
		Y_FILE_NAME: string  := "C:/Users/maria/OneDrive/Documents/TCC/dados_simulacao_4_y.mif"
		);
		
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		Y_DATA: out std_logic_vector((DATA_WIDTH-1) downto 0);
		X_DATA: out std_logic_vector((DATA_WIDTH-1) downto 0);
		FINISH: out std_logic
		);


end DATA_MEMORY;


architecture behavior of DATA_MEMORY is

	signal s_addr: std_logic_vector((ADDR_WIDTH-1) downto 0);
	--signal s_finish: std_logic := '0';
	
	--constant IMG_SIZE: integer := 200;
	--constant X_FILE_NAME: string  := "C:/Users/maria/OneDrive/Documents/TCC/dados_simulacao_4_x.mif";
	--constant Y_FILE_NAME: string  := "C:/Users/maria/OneDrive/Documents/TCC/dados_simulacao_4_y.mif";

--- Declaração dos componentes-------------------------------------
	component ROM_MEM
		generic(
			ADDR_WIDTH: integer := 8;
			DATA_WIDTH: integer := 32;
			NUM_SAMPLES: integer := 200;
			DATA_FILE_NAME: string := "C:/Users/maria/OneDrive/Documents/TCC/dados_simulacao_3_x.mif");
		port(
			--CLK: in std_logic;
			ADDR: in std_logic_vector((ADDR_WIDTH-1) downto 0);
			DATA_OUT: out std_logic_vector((DATA_WIDTH-1) downto 0));
	end component;
	
	
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
--------------------------------------------------

begin

	C_ROM: ROM_MEM_CONTROL generic map(ADDR_WIDTH, NUM_SAMPLES) port map(CLK, RESET, s_addr, FINISH);
			
	X_DATA_COMPONENT: ROM_MEM generic map(ADDR_WIDTH, DATA_WIDTH, NUM_SAMPLES, X_FILE_NAME) port map(s_addr, X_DATA);
				
	Y_DATA_COMPONENT: ROM_MEM generic map(ADDR_WIDTH, DATA_WIDTH, NUM_SAMPLES, Y_FILE_NAME) port map(s_addr, Y_DATA);

end behavior;