library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity square_wave_generator is
  Port (
     clk : in std_logic;
     reset : in std_logic;
     high, low : in unsigned(3 downto 0) := "0000";
     square : out std_logic := '0'
  
   );
end square_wave_generator;

architecture Behavioral of square_wave_generator is
signal sayac  : integer range 0 to 80 := 0; -- Bu deðerler 5'e 5 olduðu zaman 100 ns oluyor her bir durum.
signal sayac2 : integer range 0 to 80 := 0; -- 80 = 16*5
begin


process(clk, reset)
begin 
   
   if(reset = '1') then
      square <= '0';
      sayac  <= 0;
      sayac2 <= 0;
      sayac  <= to_integer(high); -- Bu iki satýrý ben normalde concurrent ifade olarak process'in dýþýna yazmýþtým. Bu hatalý çünkü sayac sinyalini hem process içinde hem de cuncurrent ifade ile 
      sayac2 <= to_integer(low); -- process dýþýnda kullanmýþ oldum. Yani iki farklý süreçte kullanmýþ oldum ki hata da buydu. Bir sinyal ayný anda iki farklý süreçte kullanýlamaz. Zaten aldýðým hatada da sayac multply drive diyordu.
      -- Donanýmsal mantýk açýsýndan düþündüðümüzde, reset bir nevi sistemin baþlangýç deðerlerini yüklemek için kullanýlýr. process içine koyarsak, bu her clock döngüsünde sayacý sýfýrlar. Bu durumda sayaç hiç artmaz, çünkü her döngüde dýþarýdan gelen deðere sýfýrlanýr. 
   
   elsif(clk'event and clk = '1') then
      
      if(sayac < to_integer(high) * 5) then -- Burada *5 dememizdeki amaç projede bizden high ve low deðerleri*100 ns çýkýþ istemesiydi. Biz * 5 koymadan önce saatin bir periyodu 20 ns olduðu için high*20 þeklinde çýkýþ alýyorduk ama þimdi oraya 100/20=5 den *5 koyunca çýkýþýn 100 ns çarpýmýný almýþ olduk. 20*5 100 eder iþte.
         sayac  <= sayac + 1;
         square <= '1';
      else
      -- low durumu
         if(sayac2 < to_integer(low) * 5) then
            square <= '0';
            sayac2 <= sayac2 + 1;
         else
            square <= '1';
            sayac  <= 1; -- Bunu 0 atarsak eðer 120 ns sayýyor hýgh durumu ve sadece ilk high durumunda 100 ns (istenilen) veriyor. Bunu 1 yaparak druumu kotardýk.
            sayac2 <= 0;
         end if;
         --low durumu
      end if;
      
   end if;

end process;

end Behavioral;
