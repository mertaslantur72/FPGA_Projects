library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity LED_time_multiplexing_circuit is
  Port (
     clk : in std_logic;
     reset : in std_logic;
     in0, in1, in2, in3 : in std_logic_vector(7 downto 0);
     an : out std_logic_vector(3 downto 0);
     sseg  :out std_logic_vector(7 downto 0)  
   );
end LED_time_multiplexing_circuit;

architecture Behavioral of LED_time_multiplexing_circuit is
--Refreshing rate around 1600 Hz
constant N : integer := 8;
signal q_reg : unsigned(N-1 downto 0);
signal q_next : unsigned(N-1 downto 0);
signal sel : std_logic_vector(1 downto 0);
begin

process(clk, reset)
   begin
   --regeister
   if(reset = '1') then
      q_reg <= (others => '0');
   
   elsif(clk'event and clk = '1') then
      q_reg <= q_next;
   end if;
end process;

--next-state logic for the counter
q_next <= q_reg + 1;

-- 4-1 multiplexer'i kontrol etmek ve active-low enable sinyali üretmek için sayacýn 2 MSB'si
sel <= std_logic_vector(q_reg(N-1 downto N-2));
process(in0, in1, in2, in3)
begin
   
   case sel is
      when "00" =>
         an(3 downto 0) <= "1110";
         sseg           <= in0;
      
      when "01" =>
         an(3 downto 0) <= "1101";
         sseg           <= in1; 
         
      when "10" =>
         an(3 downto 0) <= "1011";
         sseg           <= in2;
         
      when others =>
         an(3 downto 0) <= "0111";
         sseg           <= in3;
      end case;


   end process;

end Behavioral;
