library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity moore_based_rising_edge_detector is
  Port (
     clk   : in  std_logic;
     reset : in std_logic;
     level : in std_logic;
     tick  : out std_logic
   );
end moore_based_rising_edge_detector;

architecture Behavioral of moore_based_rising_edge_detector is
type eg_state_type is (s0, s1);
signal state_reg, state_next : eg_state_type;

begin

-- state register
process(clk, reset)
begin
 
   if(reset = '1') then
      state_reg <= s0;
   
   elsif(clk'event and clk = '1') then
      state_reg <= state_next;
   end if;

end process;

-- Next state/ output logic
process(state_reg, level)
begin

state_next <= state_reg;
tick <= '0';

   case state_reg is
      when s0 =>
         if(level = '1') then
            state_next <= s1;
            tick <= '1';
         end if;
         
      when s1 =>
         if(level = '0') then
            state_next <= s0;
         end if;
   end case;
   
end process;

end Behavioral;