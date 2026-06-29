library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity COST_FUNCTION is
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

end COST_FUNCTION;


architecture behavior of COST_FUNCTION is
		
	
		signal xbuffer3, xbuffer2, xbuffer1: signed(DATA_WIDTH-1 downto 0) := (others => '0');
		signal ybuffer2, ybuffer1: signed(DATA_WIDTH-1 downto 0):= (others => '0');
		signal s_j_acumulado: signed(DATA_WIDTH-1 downto 0) := (others => '0');
		
begin

	process(CLK, RESET)
		
		variable aux1, aux2, aux3, aux4, aux5, aux6 : signed((2*DATA_WIDTH)-1 downto 0);
		variable diff : signed(DATA_WIDTH-1 downto 0);
		variable s_y_estimado : signed(DATA_WIDTH-1 downto 0);
		
	begin 
		if (RESET = '0') then
		   xbuffer3 <= (others => '0');
			xbuffer2 <= (others => '0');
			xbuffer1 <= (others => '0');
			ybuffer2 <= (others => '0');
			ybuffer1 <= (others => '0');
			s_j_acumulado <= (others => '0');
			Y_EST <= (others => '0');
			J <= (others => '0');
		
		elsif (rising_edge(CLK)) then
		
			-- atualiza buffer da entrada
			xbuffer3 <= xbuffer2;
			xbuffer2 <= xbuffer1;
			xbuffer1 <= signed(X_DATA);			
				
			-- calcula saida do sys
			aux1 := shift_right(signed(B1)*xbuffer2, FRACTION_BITS);
			aux2 := shift_right(signed(B2)*xbuffer3, FRACTION_BITS);
			aux3 := shift_right(signed(A1)*ybuffer1, FRACTION_BITS);
			aux4 := shift_right(signed(A2)*ybuffer2, FRACTION_BITS);
			
			aux5 := aux1+aux2-aux3-aux4;
				
			s_y_estimado := resize(aux5, DATA_WIDTH);
				
			-- atualizada buffer da saída		
			
			ybuffer2 <= ybuffer1;
			ybuffer1 <= s_y_estimado;
				
			-- atualiza custo
				
			diff := s_y_estimado - signed(Y_DATA);
			aux6 := shift_right(diff*diff, FRACTION_BITS);
			s_j_acumulado <= s_j_acumulado + resize(aux6, DATA_WIDTH);
			
			
			--atualiza saidas
			Y_EST <= std_logic_vector(s_y_estimado);
			J <= std_logic_vector(s_j_acumulado);
				
		end if;
	
	end process;
		
	
end behavior;