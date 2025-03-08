library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BCD_tb is
end BCD_tb;

architecture testbench of BCD_tb is
--DUT (Device Under Test) i�in sinyaller
signal clk   : std_logic :='0'; -- Test bench yazarken bunlar�n da hep ba�lang�� de�erleri yaz�lmal�ym��. Yayg�n olarak 0'dan ba�lat�lm�� ve saat k�sm�nda 0,1,0,1,.. olarak yap�lm��.
signal reset : std_logic :='1'; -- Sim�lasyona temiz bir ba�lang�� i�in genelde reset sinyali 1 ile ba�lat�l�r.
signal cikis : std_logic_vector(11 downto 0);

-- Saat periyodu i�in sabit tan�mlama
constant CLK_PERIOD : time := 10 ns; -- 10 ns saat periyodu
-- Burada constant diyip ba�l�yoruz ve CLK_PERIOD ad�ndan, sim. boyunca de�i�meyecek bir sabit de�er at�yoruz.
-- Bunun veri tipini de time yap�yoruz(evet, �yle bir de�i�ken tipi varm�� ve ns ve ps(piko second) de�erleri al�yor).
-- Daha sonra CLK_PERIOD adl� sabitimizin de�erini 10 ns oalrak ayarl�yoruz ve bu de�er sim. boyunca de�i�miyor.

begin
-- Test edilen BCD mod�l�n� ba�lama
uut: entity work.BCD
   port map(
      clk   => clk,
      reset => reset,
      cikis => cikis
   );
-- Saat sinyali �retme s�reci
clk_process : process -- Buraya sadece process'de diyebilirdik, sorun olmazd�. Fakat biz b�yle yazd�k.
begin
   while now < 500 ns loop -- 50 saat d�ng�s� = 50*10 ns = 500 ns
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
   end loop;
   wait; -- Sonsuz d�ng�y� durdur
end process;

-- Test senrayosu
stimulus_process: process
begin
-- Ba�lang��ta reset sinyali aktif yap
   wait for 20 ns; -- Burada saat �retti�imiz anda 1 yapt���m�z reset sinyalini 20 ns yani 2 d�ng� kadar 1 tutuyoruz.
   --��nk� ger�ek sistemelrde sistemin oturmas� ve ba�lang��ta hatalara mahal vermemek ad�na gegnelde sistem 2 d�ng� reset verilir.
   reset <= '0'; -- Reset sinyalini kald�r
   wait for 500 ns; -- 50 saat periyodu bekle
   wait; -- Sonsuz d�ng�ye girmemesi i�in bunu da yazmak gerekiyormu�.
end process;
end testbench;
