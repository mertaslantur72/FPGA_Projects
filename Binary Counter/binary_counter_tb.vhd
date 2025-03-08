library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binary_counter_tb is
--  Port ( );
end binary_counter_tb;

architecture Behavioral of binary_counter_tb is
constant N : integer := 5; -- N bitlik say�c�
signal clk        : std_logic;
signal reset      : std_logic;
signal cikis      : std_logic_vector(N-1 downto 0);
signal max_flag   : std_logic;
signal min_flag   : std_logic;
signal up_or_down : std_logic := '0';
signal load       : unsigned(N-1 downto 0) := (N-1 downto 0 => '0');
signal sync_clr   : std_logic := '0';
signal en         : std_logic := '1';
--constant clk_period : time := 10 ns; Bu yap�y� da kullanmay� dene bi ara

begin

uut : entity work.binary_counter
   generic map(N => N)
   port map(
      clk        => clk,
      reset      => reset,
      cikis      => cikis,
      max_flag   => max_flag,
      min_flag   => min_flag,
      up_or_down => up_or_down,
      load       => load,
      sync_clr   => sync_clr,
      en         => en
   );

clk_process : process
begin

   while now < 5000 ns loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
   end loop;
   wait;
end process;

stimulus_test : process
begin

-- 1) Reset Testi
   reset <= '1';
   wait for 20 ns;
   reset <= '0';
   wait for 50 ns;

   -- 2) Yukar� sayma testi (1'er 1'er art��)
   up_or_down <= '0';
   load <= "00000";
   wait for 200 ns;

   -- 3) �zel y�kleme testi (y�klenen de�erin eklenmesi)
   load <= "00101"; -- 5 ekle
   wait for 20 ns;
   load <= "00000"; 
   wait for 200 ns;

   -- 4) A�a�� sayma testi
   up_or_down <= '1';
   wait for 200 ns;

   -- 5) �zel y�kleme testi (y�klenen de�erin ��kar�lmas�)
   load <= "00011"; -- 3 ��kar
   wait for 20 ns;
   load <= "00000";
   wait for 200 ns;

   -- 6) Min ve Max Flag Testi
   up_or_down <= '0';
   load <= "11111"; -- Max de�ere ula�
   wait for 100 ns;
   load <= "00000";
   wait for 200 ns;
   up_or_down <= '1';
   load <= "11111"; -- Min de�ere ula�
   wait for 100 ns;
   load <= "00000";
   wait for 200 ns;

   -- 7) Enable Testi
   en <= '0'; -- Sayac� durdur
   wait for 100 ns;
   en <= '1'; -- Sayac� devam ettir
   wait for 200 ns;

   -- 8) Senkron Clear Testi
   sync_clr <= '1';
   wait for 15 ns;
   sync_clr <= '0';
   wait for 200 ns;

wait;
end process;

end Behavioral;
