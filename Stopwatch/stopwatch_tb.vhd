library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stop_watch_test is
   --port();
end stop_watch_test;

architecture Behavioral of stop_watch_test is
   signal clk        : std_logic := '0';
   signal reset      : std_logic := '1';
   signal sync_reset : std_logic := '0';
   signal stop       : std_logic := '0';
   signal cikis      : std_logic;
   signal basamak1   : std_logic_vector(7 downto 0);
   signal basamak2   : std_logic_vector(7 downto 0);
   signal basamak3   : std_logic_vector(7 downto 0);
begin
 
 uut: entity work.stopwatch
    port map(
       clk        => clk,
       reset      => reset,
       sync_reset => sync_reset,
       stop       => stop,
       cikis      => cikis,
       basamak1   => basamak1,
       basamak2   => basamak2,
       basamak3   => basamak3
       
    );
    
    
 clk_pro: process
 begin
 while now < 40000 ms loop
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
 end loop;
 wait;
 end process;

 stimulus_test : process
 begin
 
 reset <= '1';
 wait for 50 ns;
 reset <= '0';
 wait for 1800 ms;
 sync_reset <= '1';
 wait for 20 ns ;
 sync_reset <= '0';
 wait for 4200 ms;
 stop <= '1';
 wait for 1200 ms;
 stop <= '0';
 wait for 800 ms;
 
 wait for 32000 ms;
 
 wait;
 end process;
 
 end Behavioral;