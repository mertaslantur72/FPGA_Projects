library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity square_wave_generator_tb is
--  Port ( );
end square_wave_generator_tb;

architecture Behavioral of square_wave_generator_tb is
signal clk : std_logic := '0';
signal reset : std_logic := '1';
signal square : std_logic := '0';
signal high : unsigned(3 downto 0) := "0000";
signal low : unsigned(3 downto 0) := "0000";
begin

uut: entity work.square_wave_generator
   port map(
      clk => clk,
      reset => reset,
      square => square,
      high  => high,
      low  => low
   );
   
clk_process: process
begin
   while now < 20 ms loop
   clk <= '0';
   wait for 10 ns;
   clk <= '1';
   wait for 10 ns;
   
   end loop;
   wait;
end process;


stimulus_test: process
begin
-- Resetleme yapýlýyor
reset <= '1';
wait for 20 ns;
reset <= '0';
-- Test 1
high <= "0101"; -- 5
low <= "0010"; -- 2
wait for 5 ms;
-- Test 2
high <= "1111"; -- 15
low <= "0001"; -- 1
wait for 5 ms;
-- Test 3
high <= "1111"; -- 15
low <= "1111"; -- 15
wait for 5 ms;
-- Test 4
high <= "0001"; -- 1
low <= "1111"; -- 15
wait for 5 ms;

wait;

end process;

end Behavioral;
