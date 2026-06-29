library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_particle_update is
end tb_particle_update;

architecture behavior of tb_particle_update is
	component PARTICLE_UPDATE
		generic(
			FRACTION_BITS : natural := 20;
	        NUM_ELEM : natural := 4;
	        DATA_WIDTH : natural := 32);
		port(
			en, CLK, RESET : in std_logic;
        
		    current_pos: in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
         	current_velocity : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
		   	best_personal_pos : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
         	best_global_pos : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        
		   	r1, r2: in std_logic_vector(NUM_ELEM*FRACTION_BITS-1 downto 0);
         	c1, c2: in std_logic_vector(DATA_WIDTH-1 downto 0);
         	w : in std_logic_vector(DATA_WIDTH-1 downto 0);
        
		 	new_pos : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
		 	new_velocity : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
		 	finish : out std_logic);
	 end component;
	
	constant T: time := 20 ns;
	constant FRACTION_BITS : natural := 20;
	constant	NUM_ELEM: natural := 4;
	constant DATA_WIDTH  : natural := 32;
	
	signal CLK,RESET, en: std_logic := '0';
	signal current_pos:  std_logic_vector(NUM_ELEM*DATA_WIDTH-1  downto 0);
	signal current_velocity : std_logic_vector(NUM_ELEM*DATA_WIDTH-1  downto 0);
	signal best_personal_pos : std_logic_vector(NUM_ELEM*DATA_WIDTH-1  downto 0);
	signal best_global_pos : std_logic_vector(NUM_ELEM*DATA_WIDTH-1  downto 0);
		
	signal r1, r2 : std_logic_vector(NUM_ELEM*FRACTION_BITS-1  downto 0);
	signal c1, c2 : std_logic_vector(DATA_WIDTH-1 downto 0);
	signal w : std_logic_vector(DATA_WIDTH-1 downto 0);
	
	signal new_pos : std_logic_vector(NUM_ELEM*DATA_WIDTH-1  downto 0);
	signal new_velocity : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
	signal finish: std_logic;
	
	signal v0, v1, v2, v3 : signed(DATA_WIDTH-1 downto 0);
	signal p0, p1, p2, p3 : signed(DATA_WIDTH-1 downto 0);


begin
	L0: PARTICLE_UPDATE generic map(FRACTION_BITS,NUM_ELEM,DATA_WIDTH)
				  port map(en, CLK, RESET, current_pos,current_velocity, best_personal_pos, best_global_pos, r1, r2,c1, c2, w, new_pos, new_velocity, finish);
	
	v0 <= signed(new_velocity(31 downto 0));
   	v1 <= signed(new_velocity(63 downto 32));
	v2 <= signed(new_velocity(95 downto 64));
	v3 <= signed(new_velocity(127 downto 96));

   	p0 <= signed(new_pos(31 downto 0));
	p1 <= signed(new_pos(63 downto 32));
   	p2 <= signed(new_pos(95 downto 64));
   	p3 <= signed(new_pos(127 downto 96));
		
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
		en <= '0';
		wait for 2*T;
		RESET <='1';
		
		w <= std_logic_vector(to_signed(734003, DATA_WIDTH));
      	c1 <= std_logic_vector(to_signed(1468006, DATA_WIDTH));
      	c2 <= std_logic_vector(to_signed(1468006, DATA_WIDTH));
		
		r1 <= std_logic_vector(to_unsigned(441982, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(745279, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(372639, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(186319, FRACTION_BITS));
				
	
		r2 <= std_logic_vector(to_unsigned(780267, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(390133, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(719354, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(883965, FRACTION_BITS));
	
	 
		current_pos <= std_logic_vector(to_signed(1038182, DATA_WIDTH))  & 
							std_logic_vector(to_signed(-2084108, DATA_WIDTH)) &
							std_logic_vector(to_signed(240232, DATA_WIDTH))   &
							std_logic_vector(to_signed(-202995, DATA_WIDTH));
													
		current_velocity <=  std_logic_vector(to_signed(-537, DATA_WIDTH))  & 
									std_logic_vector(to_signed(-2171, DATA_WIDTH)) &
									std_logic_vector(to_signed(-797, DATA_WIDTH))  &
									std_logic_vector(to_signed(509, DATA_WIDTH));


		best_personal_pos <= std_logic_vector(to_signed(1037236, DATA_WIDTH))  & 
									std_logic_vector(to_signed(-2083693, DATA_WIDTH)) &
									std_logic_vector(to_signed(240302, DATA_WIDTH))   &
									std_logic_vector(to_signed(-202682, DATA_WIDTH));

	  
		best_global_pos <= std_logic_vector(to_signed(1037480, DATA_WIDTH))  & 
								 std_logic_vector(to_signed(-2084207, DATA_WIDTH)) &
								 std_logic_vector(to_signed(240311, DATA_WIDTH))   &
								 std_logic_vector(to_signed(-203330, DATA_WIDTH));
		
	
		
		wait for 2*T;
		en <= '1';
		wait for T; 
		en <= '0';
		  
		wait until finish = '1';
		  
		wait for 2*T; 
		
		------ iteracao 51
		current_pos <= new_pos;
		current_velocity <= new_velocity;

		r1 <= std_logic_vector(to_unsigned(949948, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(999262, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(1023919, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(511959, FRACTION_BITS));
				
	
		r2 <= std_logic_vector(to_unsigned(519110, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(259555, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(654065, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(851320, FRACTION_BITS));
	
		wait for 2*T;	
		en <= '1';
		wait for T; 
		en <= '0';
		   
		wait until finish = '1';
		  
		wait for 2*T; 
		
		--iteracao 52
		current_pos <= new_pos;
		current_velocity <= new_velocity;

		r1 <= std_logic_vector(to_unsigned(965738, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(1007157, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(1027866, FRACTION_BITS)) & 
            std_logic_vector(to_unsigned(1038221, FRACTION_BITS));
				
	
		r2 <= std_logic_vector(to_unsigned(771755, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(385877, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(717226, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(882901, FRACTION_BITS));

		wait for 2*T;
		
		en <= '1';
		wait for T; 
		en <= '0';
		  		  
		wait until finish = '1';
		  
		wait for 2*T; 
		
		-- iteracao 53
		current_pos <= new_pos;
		current_velocity <= new_velocity;


		r1 <= std_logic_vector(to_unsigned(813756, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(931166, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(989871, FRACTION_BITS)) & 
			std_logic_vector(to_unsigned(494935, FRACTION_BITS));
				
	
		r2 <= std_logic_vector(to_unsigned(437188, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(218594, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(109297, FRACTION_BITS)) & 
			   std_logic_vector(to_unsigned(578936, FRACTION_BITS));
				
		best_personal_pos <= std_logic_vector(to_signed(1036930, DATA_WIDTH))  & 
									std_logic_vector(to_signed(-2083615, DATA_WIDTH)) &
									std_logic_vector(to_signed(240636, DATA_WIDTH))   &
									std_logic_vector(to_signed(-203170, DATA_WIDTH));

	  
		best_global_pos <= std_logic_vector(to_signed(1037480, DATA_WIDTH))  & 
								 std_logic_vector(to_signed(-2084207, DATA_WIDTH)) &
								 std_logic_vector(to_signed(240311, DATA_WIDTH))   &
								 std_logic_vector(to_signed(-203330, DATA_WIDTH));
	
		wait for 2*T;
		
		en <= '1';
		wait for T; 
		en <= '0';
		  
		  
		wait until finish = '1';
		  
		wait for 2*T; 

		assert false report "Simulation completed" severity failure;
										
	end process;
end behavior;
