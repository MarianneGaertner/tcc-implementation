library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom_mem is
end tb_rom_mem;

architecture behavior of tb_rom_mem is
	component ROM_MEM
		generic(
			ADDR_WIDTH: integer := 8;
			DATA_WIDTH: integer := 32;
			NUM_SAMPLES: integer := 200;
			DATA_FILE_NAME: string := "../DadosGerados/dados_simulacao_x.mif"
			);
				
		port(
			ADDR: in std_logic_vector((ADDR_WIDTH-1) downto 0);
			DATA_OUT: out std_logic_vector((DATA_WIDTH-1) downto 0)
			);
		
		
	end component;

-- sinais
	signal CLK: std_logic:= '0';
	signal DATA_OUT : std_logic_vector(31 downto 0);
	signal ADDR: std_logic_vector(7 downto 0):= (others => '0');
	
-- constantes
	constant T: time:= 20 ns;	
	constant C_ADDR_WIDTH : integer := 8;
   constant C_DATA_WIDTH : integer := 32;
   constant C_NUM_SAMPLES   : integer := 200;
   constant C_FILE_NAME  : string  := "../DadosGerados/dados_simulacao_x.mif";
	
begin
	L0: ROM_MEM generic map(C_ADDR_WIDTH, C_DATA_WIDTH, C_NUM_SAMPLES, C_FILE_NAME) 
					port map(ADDR, DATA_OUT);

	
	process
	begin			
		for i in 0 to C_NUM_SAMPLES-1 loop
			ADDR <= std_logic_vector(to_unsigned(i,C_ADDR_WIDTH));
			wait for T;		
		end loop;
			
      assert false report "simulation completed" severity failure;
	end process;


end behavior;
