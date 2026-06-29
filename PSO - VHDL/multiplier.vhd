library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    generic(
        FRACTION_BITS: natural := 20;
        DATA_WIDTH: natural := 32;
        NUM_ELEM: natural := 4
    );
    port(
        CLK, RESET : in std_logic;
        FLAG: in std_logic;
        x1 : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        x2 : in std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        y : out std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
        finish : out std_logic
    );
end multiplier;

architecture behavior of multiplier is

    signal y_reg : std_logic_vector(NUM_ELEM*DATA_WIDTH-1 downto 0);
    signal count : natural range 0 to NUM_ELEM;
	 
begin

    y <= y_reg;

    process(CLK, RESET)
        variable aux1, aux2 : signed(DATA_WIDTH-1 downto 0);
        variable mult: signed(2*DATA_WIDTH-1 downto 0);
    begin
	 
       if(RESET = '0') then
            count <= 0;
            finish <= '0';
            y_reg <= (others => '0');
				
        elsif (rising_edge(CLK)) then
            if (count < NUM_ELEM) then
                
					 finish <= '0';
                
                if (FLAG = '0') then
                    aux1 := signed(x1(DATA_WIDTH-1 downto 0));
                else
                    aux1 := signed(x1((count+1)*DATA_WIDTH-1 downto count*DATA_WIDTH));
                end if;
                
                aux2 := signed(x2((count+1)*DATA_WIDTH-1 downto count*DATA_WIDTH));
                
              
                mult := aux1*aux2;
					 
                y_reg((count+1)*DATA_WIDTH-1 downto count*DATA_WIDTH) <= 
                    std_logic_vector(resize(shift_right(mult, FRACTION_BITS), DATA_WIDTH));
                
                count <= count + 1;
            elsif (count = NUM_ELEM) then--else
                finish <= '1';
					 count <= 0; 
            end if;
        end if;
    end process;
end behavior;