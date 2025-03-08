library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BCD_tb is
end BCD_tb;

architecture testbench of BCD_tb is
--DUT (Device Under Test) için sinyaller
signal clk   : std_logic :='0'; -- Test bench yazarken bunlarýn da hep baþlangýç deðerleri yazýlmalýymýþ. Yaygýn olarak 0'dan baþlatýlmýþ ve saat kýsmýnda 0,1,0,1,.. olarak yapýlmýþ.
signal reset : std_logic :='1'; -- Simülasyona temiz bir baþlangýç için genelde reset sinyali 1 ile baþlatýlýr.
signal cikis : std_logic_vector(11 downto 0);

-- Saat periyodu için sabit tanýmlama
constant CLK_PERIOD : time := 10 ns; -- 10 ns saat periyodu
-- Burada constant diyip baþlýyoruz ve CLK_PERIOD adýndan, sim. boyunca deðiþmeyecek bir sabit deðer atýyoruz.
-- Bunun veri tipini de time yapýyoruz(evet, öyle bir deðiþken tipi varmýþ ve ns ve ps(piko second) deðerleri alýyor).
-- Daha sonra CLK_PERIOD adlý sabitimizin deðerini 10 ns oalrak ayarlýyoruz ve bu deðer sim. boyunca deðiþmiyor.

begin
-- Test edilen BCD modülünü baðlama
uut: entity work.BCD
   port map(
      clk   => clk,
      reset => reset,
      cikis => cikis
   );
-- Saat sinyali üretme süreci
clk_process : process -- Buraya sadece process'de diyebilirdik, sorun olmazdý. Fakat biz böyle yazdýk.
begin
   while now < 500 ns loop -- 50 saat döngüsü = 50*10 ns = 500 ns
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
   end loop;
   wait; -- Sonsuz döngüyü durdur
end process;

-- Test senrayosu
stimulus_process: process
begin
-- Baþlangýçta reset sinyali aktif yap
   wait for 20 ns; -- Burada saat ürettiðimiz anda 1 yaptýðýmýz reset sinyalini 20 ns yani 2 döngü kadar 1 tutuyoruz.
   --Çünkü gerþek sistemelrde sistemin oturmasý ve baþlangýçta hatalara mahal vermemek adýna gegnelde sistem 2 döngü reset verilir.
   reset <= '0'; -- Reset sinyalini kaldýr
   wait for 500 ns; -- 50 saat periyodu bekle
   wait; -- Sonsuz döngüye girmemesi için bunu da yazmak gerekiyormuþ.
end process;
end testbench;
