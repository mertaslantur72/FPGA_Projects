library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BCD is
  Port (
    clk     : in std_logic;  -- Clock sinyali
    reset   : in std_logic;  -- Reset sinyali (senkron reset)
    cikis   : out std_logic_vector(11 downto 0)  -- 12 bitlik BCD ��k��
  );
end BCD;

architecture Behavioral of BCD is
signal sayi_decimal : integer range 0 to 999 := 619;
signal birler, onlar, yuzler : unsigned(3 downto 0) := (others => '0');
 
begin

process(clk, reset)
begin

if(reset = '1') then
   sayi_decimal <= 619;
   
   yuzler       <= "0110"; --6
   onlar        <= "0001"; --1
   birler       <= "1001"; --9
   
elsif(clk'event and clk = '1') then
   if(sayi_decimal < 999) then
      sayi_decimal <= sayi_decimal + 1;
   else
      sayi_decimal <= 0;   
   end if;
   --BCD d�n���m�
   yuzler <= to_unsigned((sayi_decimal/100),4);
   onlar  <= to_unsigned((sayi_decimal mod 100)/10,4);
   birler <= to_unsigned((sayi_decimal mod 10),4);
end if;
-- VHDL�de "<=" ile yap�lan atamalar, bir sonraki saat d�ng�s�ne kadar ger�ekle�mez.3. y�k.kenarda sayi_decimal de�eri 619->620 yapl�r ama ��k��a hala 619 verilir.
-- Yeni de�er olan 620 bir sonraki y�kselen kenarda ��k��a verilir ve o kenarda da say_decimal de�eri 620->621 yap�lm�� olunur.
end process;
cikis <= std_logic_vector(yuzler) & std_logic_vector(onlar) & std_logic_vector(birler);

end Behavioral;
