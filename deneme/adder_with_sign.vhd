library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity adder_with_sign is
  Port (
     a, b  : in  std_logic_vector(3 downto 0);
     sum   : out std_logic_vector(3 downto 0);
     iflas : out std_logic  -- Yeni eklenen ��k��
   );
end adder_with_sign;

architecture Behavioral of adder_with_sign is
signal mag_a, mag_b             : unsigned(2 downto 0);
signal mag_sum, max, min        : unsigned(2 downto 0);
signal sign_a, sign_b, sign_sum : std_logic;
signal overflow_check           : unsigned(3 downto 0); -- Overflow'u anlamak i�in 4 bitlik bir sinyal

begin

mag_a  <= unsigned(a(2 downto 0));
mag_b  <= unsigned(b(2 downto 0));
sign_a <= a(3);
sign_b <= b(3);

process(mag_a, mag_b, sign_a, sign_b)
begin
   if (mag_a > mag_b) then
      max      <= mag_a;
      min      <= mag_b;
      sign_sum <= sign_a;
   
   elsif(mag_b > mag_a) then
      max      <= mag_b;
      min      <= mag_a;
      sign_sum <= sign_b;
   else
      max      <= mag_a;  -- E�er e�itse, biri max biri min olabilir.
      min      <= mag_b;
      sign_sum <= sign_a;
   end if;
end process;

-- Ger�ek toplama i�lemi ve ta�ma kontrol�
overflow_check <= ("0" & max) + ("0" & min) when (sign_a = sign_b) else ("0" & max) - ("0" & min);
mag_sum       <= overflow_check(2 downto 0);
iflas         <= overflow_check(3);  -- E�er 4. bit (en soldaki bit) 1 olursa, ta�ma (iflas) olmu� demektir.

sum <= std_logic_vector(sign_sum & mag_sum);

end Behavioral;
