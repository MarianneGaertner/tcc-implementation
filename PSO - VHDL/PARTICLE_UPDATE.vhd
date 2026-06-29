library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PARTICLE_UPDATE is
    generic(
        FRACTION_BITS : natural := 20;
        NUM_ELEM      : natural := 4;
        DATA_WIDTH    : natural := 32
    );
    port(
        en, CLK, RESET : in std_logic;
        
		  current_pos: in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        current_velocity : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
		  best_personal_pos : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        best_global_pos : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        
		  r1, r2: in std_logic_vector(NUM_ELEM*FRACTION_BITS-1 downto 0);
        c1, c2: in std_logic_vector(DATA_WIDTH-1 downto 0);
        w : in std_logic_vector(DATA_WIDTH-1 downto 0);
        
        new_pos           : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        new_velocity      : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        finish            : out std_logic
    );
end PARTICLE_UPDATE;

architecture behavior of PARTICLE_UPDATE is

    component multiplier
        generic(
            FRACTION_BITS : natural;
            DATA_WIDTH    : natural;
            NUM_ELEM      : natural);
        port(
            CLK, RESET, FLAG : in std_logic;
            x1, x2 : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
            y : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
            finish : out std_logic);
    end component;

    type states is (S0, S1, S2, S3, S4, S5, S6, S7); 
    signal state : states;
    
    signal flag, finish_multiplier, rst_multiplier : std_logic;
    signal x1, x2, y_mult : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
 --   signal acc_current_vel : signed(NUM_ELEM*DATA_WIDTH-1 downto 0);
 --   signal c_temp : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
	 signal new_velocity_reg : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
    signal new_pos_reg : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
	 signal aux1, aux2, aux20, aux3, aux30 : signed(NUM_ELEM*DATA_WIDTH-1 downto 0);

    
begin

    L0: multiplier 
        generic map(FRACTION_BITS, DATA_WIDTH, NUM_ELEM) 
        port map(CLK, rst_multiplier, flag, x1, x2, y_mult, finish_multiplier); 
	
	new_velocity <= new_velocity_reg;
   new_pos <= new_pos_reg;
		
	process(CLK, RESET)
		variable diff : signed(NUM_ELEM*DATA_WIDTH-1 downto 0);
		variable r_aux : std_logic_vector(DATA_WIDTH-1 downto 0);
	begin
		if(RESET = '0') then
			state <= S0;
			rst_multiplier <= '0';
	--		acc_current_vel <= (others => '0');	
			finish <= '0';
			new_velocity_reg <= (others => '0');
         new_pos_reg <= (others => '0');
			
			elsif(rising_edge(CLK)) then 
				--rst_multiplier <= '1';
				
				case state is
					when S0 => 
						finish <= '0';
						if(en = '1') then
							--acc_current_vel <= (others => '0');
							rst_multiplier <= '0';
							state <= S1;
						end if;
					
--------------- w* currenty_velocity ------------------------
					when S1 =>
						rst_multiplier <= '1';
						flag <= '0';
						
						 x1 <= (others => '0');
                   x1(DATA_WIDTH-1 downto 0) <= w;		
						 
                   x2 <= current_velocity;

                   if finish_multiplier = '1' then
                        aux1 <= signed(y_mult);
								rst_multiplier <= '0';
                        state <= S2;
                   end if;
						 
---------------- r1*(Pbest-P) -----------------------------
					when S2 =>
						rst_multiplier <= '1';
						flag <= '1';
						
						for i in 0 to NUM_ELEM-1 loop
                        r_aux := (others => '0');
                        r_aux(FRACTION_BITS-1 downto 0) := r1((i+1)*FRACTION_BITS-1 downto i*FRACTION_BITS);

                        x1((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= r_aux;
								
                        diff((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) :=
                            signed(best_personal_pos((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) -
                            signed(current_pos((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
                    end loop;

                    x2 <= std_logic_vector(diff);

                    if finish_multiplier = '1' then
                        aux20 <= signed(y_mult);
								r_aux := (others => '0');
								rst_multiplier <= '0';
                        state <= S3;
                    end if;
						
--------------------- c1*aux20
					when S3 => 
						rst_multiplier <= '1';
                  flag <= '0';

                  x1 <= (others => '0');
                  x1(DATA_WIDTH-1 downto 0) <= c1;
						
                  x2 <= std_logic_vector(aux20);

					  if finish_multiplier = '1' then
							aux2 <= signed(y_mult);
							rst_multiplier <= '0';
							state <= S4;
					  end if;
					  
--------------------- r2*(Gbest - P)
					when S4 => 
						rst_multiplier <= '1';
                  flag <= '1';
	
					  for i in 0 to NUM_ELEM-1 loop
							r_aux := (others => '0');
							r_aux(FRACTION_BITS-1 downto 0) :=
								 r2((i+1)*FRACTION_BITS-1 downto i*FRACTION_BITS);
	
							x1((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= r_aux;
	
							diff((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) :=
								 signed(best_global_pos((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) -
								 signed(current_pos((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
					  end loop;
	
					  x2 <= std_logic_vector(diff);
	
					  if finish_multiplier = '1' then
							aux30 <= signed(y_mult);
							rst_multiplier <= '0';
							state <= S5;
					  end if;
						
-------------- c2*aux30
					when S5 => 
						rst_multiplier <= '1';
                  flag <= '0';

--                  x1 <= (others => '0');
--                  x1(DATA_WIDTH-1 downto 0) <= c2;
						for i in 0 to NUM_ELEM-1 loop
                        x1((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= c2;
                   end loop;
                  x2 <= std_logic_vector(aux30);

					  if finish_multiplier = '1' then
							aux3 <= signed(y_mult);
							rst_multiplier <= '0';
							state <= S6;
					  end if;

--------------- soma velocidade
                when S6 =>
                    for i in 0 to NUM_ELEM-1 loop
                        new_velocity_reg((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <=
                            std_logic_vector(aux1((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) +
                                aux2((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) +
                                aux3((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH));
                    end loop;
                    state <= S7;					  
					  
---------------- atualiza posição				
					when S7 =>
						for i in 0 to NUM_ELEM-1 loop
							new_pos_reg((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH) <= 
							std_logic_vector(
                                signed(current_pos((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH)) +
                                signed(new_velocity_reg((i+1)*DATA_WIDTH-1 downto i*DATA_WIDTH))
                            );
                   end loop;

                    finish <= '1';
                    state <= S0;
-----------------------------
					when others =>
						state <= S0;
            end case;
        end if;
										
	end process;
		

   
end behavior;