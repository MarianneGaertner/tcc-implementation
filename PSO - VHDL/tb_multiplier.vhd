library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_multiplier is
end tb_multiplier;

architecture behavior of tb_multiplier is

	component multiplier 
		generic(
			FRACTION_BITS: natural := 20;
			DATA_WIDTH: natural := 32;
			NUM_ELEM: natural := 4);
		port(
			  CLK, RESET : in std_logic;
			  FLAG: in std_logic;
			  x1 : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
			  x2 : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
			  y : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
			  finish : out std_logic);
	end component;
	
	constant T: time := 20 ns;
	constant FRACTION_BITS : natural := 20;
	constant	NUM_ELEM: natural := 4;
	constant DATA_WIDTH  : natural := 32;
	signal CLK,RESET, flag: std_logic := '0';
	signal x1 : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0) := (others => '0');
	signal x2 : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0) := (others => '0');
	signal y : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
	signal finish : std_logic;
	
	signal y_elem_0   : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal y_elem_1   : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal y_elem_2   : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal y_elem_3   : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
	L0: multiplier generic map(FRACTION_BITS, DATA_WIDTH,NUM_ELEM) port map(CLK, RESET, flag, x1, x2, y, finish);
	
	y_elem_0 <= y(1*DATA_WIDTH-1 downto 0*DATA_WIDTH); -- Bits 31 downto 0
	y_elem_1 <= y(2*DATA_WIDTH-1 downto 1*DATA_WIDTH); -- Bits 63 downto 32
	y_elem_2 <= y(3*DATA_WIDTH-1 downto 2*DATA_WIDTH); -- Bits 95 downto 64
	y_elem_3 <= y(4*DATA_WIDTH-1 downto 3*DATA_WIDTH); -- Bits 127 downto 96

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
		wait for T*2;
		RESET <='1';
		wait for T*2;
		
		-- teste 1: FLAG = '1'
		-- x1 = [4.0, 3.0, 2.0, 1.5]
       -- x2 = [2.0, 2.0, 2.0, 2.0]
		 -- Resultados esperados em y: [8.0, 6.0, 4.0, 3.0] -> [8388608, 6291456, 4194304, 3145728]
		flag <= '1';
		
		x1 <= std_logic_vector(to_signed(4194304, DATA_WIDTH)) &  -- x1(3) = 4.0
			std_logic_vector(to_signed(3145728, DATA_WIDTH)) &  -- x1(2) = 3.0
			std_logic_vector(to_signed(2097152, DATA_WIDTH)) &  -- x1(1) = 2.0
			std_logic_vector(to_signed(1572864, DATA_WIDTH));   -- x1(0) = 1.5
			
		x2 <= std_logic_vector(to_signed(2097152, DATA_WIDTH)) &  -- x2(3) = 2.0
			std_logic_vector(to_signed(2097152, DATA_WIDTH)) &  -- x2(2) = 2.0
			std_logic_vector(to_signed(2097152, DATA_WIDTH)) &  -- x2(1) = 2.0
			std_logic_vector(to_signed(2097152, DATA_WIDTH));   -- x2(0) = 2.0
		
		wait until finish ='1';
		wait for 4*T;
		
		--teste 2 FLAG = '0'
		-- x1(0) = 1.5
		-- x2 = [4.0, 3.0, 2.0, 1.0] -> [4194304, 3145728, 2097152, 1048576]
		-- Resultados esperados em y: [6.0, 4.5, 3.0, 1.5] -> [6291456, 4718592, 3145728, 1572864]
		flag <= '0';
		
		x1 <= std_logic_vector(to_signed(0, DATA_WIDTH))&  -- x1(3) -> indiferente
			  std_logic_vector(to_signed(0, DATA_WIDTH))&  -- x1(2) -> indiferente
			  std_logic_vector(to_signed(0, DATA_WIDTH))     &  -- x1(1) -> indiferente
			  std_logic_vector(to_signed(1572864, DATA_WIDTH));   -- x1(0) = 1.5
              
	  	x2 <= std_logic_vector(to_signed(4194304, DATA_WIDTH)) &  -- x2(3) = 4.0
			  std_logic_vector(to_signed(3145728, DATA_WIDTH)) &  -- x2(2) = 3.0
			  std_logic_vector(to_signed(2097152, DATA_WIDTH)) &  -- x2(1) = 2.0
			  std_logic_vector(to_signed(1048576, DATA_WIDTH));   -- x2(0) = 1.0

        wait until finish = '1';
		wait for T*4;		  
		  
		assert false report "Simulation completed" severity failure;
									
		end process;

end behavior;
