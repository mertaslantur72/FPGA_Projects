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
signal sayac  : integer range 0 to 80 := 0; -- Bu de�erler 5'e 5 oldu�u zaman 100 ns oluyor her bir durum.
signal sayac2 : integer range 0 to 80 := 0; -- 80 = 16*5
begin


process(clk, reset)
begin 
   
   if(reset = '1') then
      square <= '0';
      sayac  <= 0;
      sayac2 <= 0;
      sayac  <= to_integer(high); -- Bu iki sat�r� ben normalde concurrent ifade olarak process'in d���na yazm��t�m. Bu hatal� ��nk� sayac sinyalini hem process i�inde hem de cuncurrent ifade ile 
      sayac2 <= to_integer(low); -- process d���nda kullanm�� oldum. Yani iki farkl� s�re�te kullanm�� oldum ki hata da buydu. Bir sinyal ayn� anda iki farkl� s�re�te kullan�lamaz. Zaten ald���m hatada da sayac multply drive diyordu.
      -- Donan�msal mant�k a��s�ndan d���nd���m�zde, reset bir nevi sistemin ba�lang�� de�erlerini y�klemek i�in kullan�l�r. process i�ine koyarsak, bu her clock d�ng�s�nde sayac� s�f�rlar. Bu durumda saya� hi� artmaz, ��nk� her d�ng�de d��ar�dan gelen de�ere s�f�rlan�r. 
   
   elsif(clk'event and clk = '1') then
      
      if(sayac < to_integer(high) * 5) then -- Burada *5 dememizdeki ama� projede bizden high ve low de�erleri*100 ns ��k�� istemesiydi. Biz * 5 koymadan �nce saatin bir periyodu 20 ns oldu�u i�in high*20 �eklinde ��k�� al�yorduk ama �imdi oraya 100/20=5 den *5 koyunca ��k���n 100 ns �arp�m�n� alm�� olduk. 20*5 100 eder i�te.
         sayac  <= sayac + 1;
         square <= '1';
      else
      -- low durumu
         if(sayac2 < to_integer(low) * 5) then
            square <= '0';
            sayac2 <= sayac2 + 1;
         else
            square <= '1';
            sayac  <= 1; -- Bunu 0 atarsak e�er 120 ns say�yor h�gh durumu ve sadece ilk high durumunda 100 ns (istenilen) veriyor. Bunu 1 yaparak druumu kotard�k.
            sayac2 <= 0;
         end if;
         --low durumu
      end if;
      
   end if;

end process;

end Behavioral;
