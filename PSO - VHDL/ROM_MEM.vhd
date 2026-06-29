library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity ROM_MEM is
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
end ROM_MEM;



architecture behavior of ROM_MEM is

	type type_mem is array(0 to NUM_SAMPLES) of std_logic_vector((DATA_WIDTH-1) downto 0);
	
-- função----------	
	impure function init_mem(file_name: in string) return type_mem is
		file file_r: text open read_mode is file_name;
		variable line_r: line;
		variable temp_bits: bit_vector((DATA_WIDTH-1) downto 0);
		variable temp_mem: type_mem;
		
	begin	

		for i in 0 to NUM_SAMPLES-1 loop
			readline(file_r, line_r);
			read(line_r, temp_bits);
			temp_mem(i) := to_stdlogicvector(temp_bits);
		end loop;
		
		file_close(file_r);
		return temp_mem;
	end function init_mem;
----------------------------

	signal mem_block: type_mem := init_mem(DATA_FILE_NAME);


begin
	
	DATA_OUT <= mem_block(to_integer(unsigned(ADDR)));


--	process(CLK)
--	
--	variable addr_int : integer;
--	
--	begin
--
--		if(rising_edge(CLK)) then
--		
--			addr_int := to_integer(unsigned(ADDR));		
--		
--			if (addr_int < IMG_SIZE) then
--				DATA_OUT <= mem_block(addr_int);
--				
--			end if;
--		end if;
--		
--	end process;


end behavior; 
