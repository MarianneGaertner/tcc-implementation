library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_cost_function is
end tb_cost_function;

architecture behavior of tb_cost_function is

--- components
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
	
	component COST_FUNCTION
		generic(
			ADDR_WIDTH: integer := 8;
			DATA_WIDTH  : integer := 32;
			NUM_SAMPLES: natural := 200;
			FRACTION_BITS : integer := 20
		
		);
		port(
			CLK: in std_logic;
			RESET: in std_logic;
			FINISH: in std_logic;
			
			Y_DATA: in std_logic_vector((DATA_WIDTH-1) downto 0);
			X_DATA: in std_logic_vector((DATA_WIDTH-1) downto 0);
			
			B1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
			B2 : in std_logic_vector(DATA_WIDTH-1 downto 0);
			A1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
			A2 : in std_logic_vector(DATA_WIDTH-1 downto 0);
			
			J: out std_logic_vector(DATA_WIDTH-1 downto 0);
			Y_EST: out std_logic_vector(DATA_WIDTH-1 downto 0)
			
		);
	end component;	
---------------------------------------

	constant T : time := 20 ns;
	constant ADDR_WIDTH: integer := 8;
	constant	DATA_WIDTH  : integer := 32;
	constant NUM_SAMPLES: natural := 200;
	constant FRACTION_BITS : integer := 20;
	constant B1: std_logic_vector(DATA_WIDTH-1 downto 0) := "11111111111111001110010110111110";
	constant B2: std_logic_vector(DATA_WIDTH-1 downto 0) := "00000000000000111010101010110111";
	constant A1: std_logic_vector(DATA_WIDTH-1 downto 0) := "11111111111000000011001010010001";
	constant A2: std_logic_vector(DATA_WIDTH-1 downto 0) := "00000000000011111101010010101000";
	constant X_FILE_NAME: string  := "../DadosGerados/dados_simulacao_x.mif";
	constant Y_FILE_NAME: string  := "../DadosGerados/dados_simulacao_y.mif";
	
	signal CLK: std_logic := '0';
	signal RESET: std_logic :='0';
--	signal ADDR: std_logic_vector((ADDR_WIDTH-1) downto 0);
	signal FINISH: std_logic := '0';
	
	signal X_DATA : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal Y_DATA : std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal j_out_s     : std_logic_vector(DATA_WIDTH-1 downto 0);
   signal y_est_out_s : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

	L0: DATA_MEMORY generic map(ADDR_WIDTH, DATA_WIDTH, NUM_SAMPLES, X_FILE_NAME, Y_FILE_NAME)
						port map(CLK, RESET, Y_DATA, X_DATA, FINISH);
						
	L1: COST_FUNCTION generic map(ADDR_WIDTH, DATA_WIDTH, NUM_SAMPLES, FRACTION_BITS)
							port map(CLK, RESET, FINISH, Y_DATA, X_DATA, B1, B2, A1, A2, j_out_s, y_est_out_s);
	


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
		wait for 2*T/3;
		RESET <= '1';
		
		
		wait until FINISH <= '1';
		wait for 2*T;
		
		assert false report "simulation completed" severity failure;

	
	end process;

							
	process
		file file_w : text open write_mode is "../DadosGerados/y_estimado_vhdl.txt";
		file file_j : text open write_mode is "../DadosGerados/custo_acumulado_vhdl.txt";
		
		variable v_linha :line;
		variable v_linha_j : line;
	begin
		wait until RESET ='1';
		 loop
			wait until rising_edge(CLK);
			write(v_linha, y_est_out_s);
			writeline(file_w, v_linha);
			write(v_linha_j, j_out_s);
			writeline(file_j, v_linha_j);
			
			exit when FINISH = '1';
			
		end loop;
		file_close(file_w);
		file_close(file_j);
		
	end process;



end behavior;
