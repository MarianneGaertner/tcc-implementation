library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_data_memory is
end tb_data_memory;

architecture behavior of tb_data_memory is
	component DATA_MEMORY 
		generic(
		ADDR_WIDTH: integer := 8;
		DATA_WIDTH  : integer := 32;
		NUM_SAMPLES: natural := 200;
		X_FILE_NAME: string  := "../DadosGerados/dados_simulacao_x.mif";
		Y_FILE_NAME: string  := "../DadosGerados/dados_simulacao_y.mif"
		);	
		port(
			CLK: in std_logic;
			RESET: in std_logic;
			Y_DATA: out std_logic_vector((DATA_WIDTH-1) downto 0);
			X_DATA: out std_logic_vector((DATA_WIDTH-1) downto 0);
			FINISH: out std_logic
			);
	end component;

	constant T: time := 20 ns;
	constant ADDR_WIDTH: integer :=8;
	constant DATA_WIDTH  : integer := 32;
	constant NUM_SAMPLES: natural := 200;
	constant X_FILE_NAME: string  := "../DadosGerados/dados_simulacao_x.mif";
	constant Y_FILE_NAME: string  := "../DadosGerados/dados_simulacao_y.mif";
	
	signal CLK: std_logic := '0';
	signal RESET: std_logic :='0';
	signal Y_DATA:  std_logic_vector((DATA_WIDTH-1) downto 0);
	signal X_DATA: std_logic_vector((DATA_WIDTH-1) downto 0);
	signal FINISH: std_logic := '0';
	
begin

	L0: DATA_MEMORY generic map(ADDR_WIDTH, DATA_WIDTH, NUM_SAMPLES, X_FILE_NAME, Y_FILE_NAME)
						 port map (CLK, RESET, Y_DATA, X_DATA, FINISH);
						 
	process
	begin
		CLK <= '0';
		wait for T/2;
		CLK <= '1';
		wait for T/2;
	end process;
	
	process
	begin
		RESET <= '0';
		wait for T;
		RESET <= '1';
		
		wait until FINISH = '1';
		
		wait for 2*T;
		RESET <= '0';
		
		
		assert false report "simulation completed" severity failure;
	
	end process;
	
	
end behavior;
