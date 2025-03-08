library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity binary_counter is
  generic(N : integer := 5);
  Port (
     clk : in std_logic;
     reset : in std_logic;
     cikis : out std_logic_vector(N-1 downto 0);
     max_flag : out std_logic;
     min_flag : out std_logic;
     up_or_down : in std_logic := '0';
     load : in unsigned(N-1 downto 0);
     sync_clr : in std_logic;
     en : std_logic
     
   );
end binary_counter;

architecture Behavioral of binary_counter is
signal tutucu  :unsigned(N-1 downto 0) := (others =>'0');

begin

   process(clk,reset)
   begin
   
      if(reset = '1') then
         tutucu    <= (others => '0');
         -- up_or_down <= '0'; Bunu yapamad�m ��nk� giri�i sen burda ayarlayamas�n dedi.
         
      elsif(clk'event and clk = '1') then
         
         if(sync_clr = '0' and en = '1') then
            
            if(up_or_down = '0') then -- Bu durumda binary artt�rma yap�yor(ileri sayma)
               if(load = (N-1 downto 0 => '0') ) then
                  tutucu <= tutucu +1;
               else
                  tutucu <= tutucu +load;
               end if;
            
            elsif(up_or_down = '1') then -- Bu durumda binary azaltma yap�yor(geri sayma)
               if(load = (N-1 downto 0 => '0') ) then
                  tutucu <= tutucu -1;
               else
                  tutucu <= tutucu - load;
               end if;
               
            end if; -- up_or_down endi
         
         elsif(sync_clr = '1' and en ='1') then
            tutucu <= (N-1 downto 0 => '0'); -- tutucuyu yani ��k��� s�f�rlad�k
            
         else
            null;
            
         end if; --sync and en endi
      
      end if; -- clk endi
   
   end process; 
   
-- Flag'leri g�ncelle (concurrent atama)
max_flag <= '1' when tutucu = (N-1 downto 0 => '1') and reset = '0' else '0';
min_flag <= '1' when tutucu = (N-1 downto 0 => '0') and reset = '0' else '0';
--Bunlar� saatten di�ar� yazd�k ��nk� saatin i�erisinde oldu�u zaman ��k��a gecekmeli yans�yordu. Fakat d��ar�ya ve processiz bir �ekilde yaz�nca concurrent bir ifade oldular
--bu da anl�k olarak yani tutucu de�i�ti�i gibi direkt olarak de�i�imi yakalayabildikleri ve ��k��a an�nda verebildikleri anlam�na gelir. Dikkat et, saatten ayr� bir process i�inde
--yazsak bile yine de olmuyor. D��ar�da concurrent ifade olmas� gerek. O zaman her an anl�k g�ncelleniyor. 

--�lk ba�ta ben kodu N bitli�e �evirdi�imde [ max_flag <= '1' when tutucu = (others => '1') and reset = '0' else '0'; ] �eklinde yazm��t�m. fakat bu sim. hatas� almama
--ve sim. in hi� �al��mamas�na neden oldu. Bunun sebebi de tutucu'nun boyutu derleme esnas�nda tam olarak bilinemedi�i i�in hata veriyormu�. Mesela tutucu 4 bitlik olsa
--en ba�ta o zaman others ifadesi kullan�labiliyor ama N bitlik olunca olmuyor. ��nk� others hepsine (t�m bitlere) bunu ver demekmi�. E ka� bitlik oldu�u da bilinmedi�ine g�re...
--signal tutucu  :unsigned(N-1 downto 0) := (others =>'0'); sat�r�nda nas�l �al��t� diye d���necek olursan da, asl�nda orada da (N-1 downto 0 => '1') yap�s� tercih edilse daha iyi olurmu�.
--S�n�rland�r�lm�� t�rler, boyutu (�rne�in, bit geni�li�i) derleme zaman�nda bilinen t�rlerdir. �rnek: std_logic_vector(7 downto 0) veya unsigned(3 downto 0). Bu t�rlerde OTHERS ifadesi kullan�labilir ��nk� boyutlar� bellidir.
--S�n�rland�r�lmam�� T�rler:S�n�rland�r�lmam�� t�rler, boyutu derleme zaman�nda bilinmeyen t�rlerdir. �rnek: std_logic_vector veya unsigned (boyut belirtilmeden). Bu t�rlerde OTHERS ifadesi kullan�lamaz ��nk� boyutlar� belirsizdir.

cikis <= std_logic_vector(tutucu(N-1 downto 0)); -- �n�ne ta�ma biti eklemek laz�m..
-- ��k��� process'in i�ine yaz�nca ��k�� saatin y�kselen tikinin yar�s�nda veriliyor. Yani ��k�� 5 ns gecikme ile al�n�yor.
--Amam process'in d���nda olursa saatin y�kselen kenar� ile ayn� anda �ok�� da de�i�iyor.
-- Bunun sebebi ise process'in d���nda oldu�u zaman cikis, concurrent atama oluyor, yani her an ge�erli durum. tutucu de�i�ti�i gibi
--bu de�i�im ��k��a yans�yor. Ama process'in i�inde olunca saadece y�kselen tick'de cikisa g�ncelleniyor ve bu da bi gecikmeye ndn olyr
end Behavioral;
