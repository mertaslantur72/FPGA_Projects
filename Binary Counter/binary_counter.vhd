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
         -- up_or_down <= '0'; Bunu yapamadým çünkü giriþi sen burda ayarlayamasýn dedi.
         
      elsif(clk'event and clk = '1') then
         
         if(sync_clr = '0' and en = '1') then
            
            if(up_or_down = '0') then -- Bu durumda binary arttýrma yapýyor(ileri sayma)
               if(load = (N-1 downto 0 => '0') ) then
                  tutucu <= tutucu +1;
               else
                  tutucu <= tutucu +load;
               end if;
            
            elsif(up_or_down = '1') then -- Bu durumda binary azaltma yapýyor(geri sayma)
               if(load = (N-1 downto 0 => '0') ) then
                  tutucu <= tutucu -1;
               else
                  tutucu <= tutucu - load;
               end if;
               
            end if; -- up_or_down endi
         
         elsif(sync_clr = '1' and en ='1') then
            tutucu <= (N-1 downto 0 => '0'); -- tutucuyu yani çýkýþý sýfýrladýk
            
         else
            null;
            
         end if; --sync and en endi
      
      end if; -- clk endi
   
   end process; 
   
-- Flag'leri güncelle (concurrent atama)
max_flag <= '1' when tutucu = (N-1 downto 0 => '1') and reset = '0' else '0';
min_flag <= '1' when tutucu = (N-1 downto 0 => '0') and reset = '0' else '0';
--Bunlarý saatten diþarý yazdýk çünkü saatin içerisinde olduðu zaman çýkýþa gecekmeli yansýyordu. Fakat dýþarýya ve processiz bir þekilde yazýnca concurrent bir ifade oldular
--bu da anlýk olarak yani tutucu deðiþtiði gibi direkt olarak deðiþimi yakalayabildikleri ve çýkýþa anýnda verebildikleri anlamýna gelir. Dikkat et, saatten ayrý bir process içinde
--yazsak bile yine de olmuyor. Dýþarýda concurrent ifade olmasý gerek. O zaman her an anlýk güncelleniyor. 

--Ýlk baþta ben kodu N bitliðe çevirdiðimde [ max_flag <= '1' when tutucu = (others => '1') and reset = '0' else '0'; ] þeklinde yazmýþtým. fakat bu sim. hatasý almama
--ve sim. in hiç çalýþmamasýna neden oldu. Bunun sebebi de tutucu'nun boyutu derleme esnasýnda tam olarak bilinemediði için hata veriyormuþ. Mesela tutucu 4 bitlik olsa
--en baþta o zaman others ifadesi kullanýlabiliyor ama N bitlik olunca olmuyor. Çünkü others hepsine (tüm bitlere) bunu ver demekmiþ. E kaç bitlik olduðu da bilinmediðine göre...
--signal tutucu  :unsigned(N-1 downto 0) := (others =>'0'); satýrýnda nasýl çalýþtý diye düþünecek olursan da, aslýnda orada da (N-1 downto 0 => '1') yapýsý tercih edilse daha iyi olurmuþ.
--Sýnýrlandýrýlmýþ türler, boyutu (örneðin, bit geniþliði) derleme zamanýnda bilinen türlerdir. Örnek: std_logic_vector(7 downto 0) veya unsigned(3 downto 0). Bu türlerde OTHERS ifadesi kullanýlabilir çünkü boyutlarý bellidir.
--Sýnýrlandýrýlmamýþ Türler:Sýnýrlandýrýlmamýþ türler, boyutu derleme zamanýnda bilinmeyen türlerdir. Örnek: std_logic_vector veya unsigned (boyut belirtilmeden). Bu türlerde OTHERS ifadesi kullanýlamaz çünkü boyutlarý belirsizdir.

cikis <= std_logic_vector(tutucu(N-1 downto 0)); -- önüne taþma biti eklemek lazým..
-- Çýkýþý process'in içine yazýnca çýkýþ saatin yükselen tikinin yarýsýnda veriliyor. Yani çýkýþ 5 ns gecikme ile alýnýyor.
--Amam process'in dýþýnda olursa saatin yükselen kenarý ile ayný anda çokýþ da deðiþiyor.
-- Bunun sebebi ise process'in dýþýnda olduðu zaman cikis, concurrent atama oluyor, yani her an geçerli durum. tutucu deðiþtiði gibi
--bu deðiþim çýkýþa yansýyor. Ama process'in içinde olunca saadece yükselen tick'de cikisa güncelleniyor ve bu da bi gecikmeye ndn olyr
end Behavioral;
