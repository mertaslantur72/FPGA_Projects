library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity stopwatch is
  Port (
     clk        : in std_logic;
     reset      : in std_logic;
     sync_reset : in std_logic; -- Kronometreyi senkron bir şekilde (clk ile) buton/switch 1 olduğunda başlangıç anına döndürür.
     stop       : in std_logic := '0'; -- Kronometreyi durdurup başlatmaya yarar.
     cikis      : buffer std_logic; -- Buradan 0.1 saniyede bir 1 olan bir çıkış alıyoruz. Yani 0.1 er sayma işlemi sonucu bu.
     basamak1   : out std_logic_vector(7 downto 0) := (others => '0'); -- En sağ basamak
     basamak2   : out std_logic_vector(7 downto 0) := (others => '0'); -- Bu basamak 8 bit çünkü bunun noktası sürekli yanacak, onun bilgisi var içinde.
     basamak3   : out std_logic_vector(7 downto 0) := (others => '0') -- En sol basamak
   );
end stopwatch;

architecture Behavioral of stopwatch is
signal q_reg     : unsigned(22 downto 0) := (others => '0'); -- 0.1 saniye de bir saymak için 5.000.000 sayısını tutabilecek bit sayısı.
signal sayac     : integer range 0 to 9 :=0; -- Bununla milisaniye kısmını sayıyoruz.
signal sayac2    : integer range 0 to 9 :=0; -- Bununla ortanca basamak sayılıyor.
signal sayac3    : integer range 0 to 9 :=0; -- Bu da en sol basamağı sayıyor. Bunlar unsigned olmaz mıydı???
signal cikis_reg : std_logic := '0';  -- cikis'in bir önceki durumunu tutar. Bu 0.1 adetini saymak için uydurduğum bir şey, tamamiyle kod çalışsın diye var. Bu olmadan çalışmadığı için var. Bu neden var??? Ben de bilmiyorum.

begin

process(clk, reset, sync_reset, stop)
begin 
   if (reset = '1') then
      q_reg     <= (others => '0');
      sayac     <= 0;
      sayac2    <= 0;
      sayac3    <= 0;
      cikis     <= '0'; 
      cikis_reg <= '0';
      basamak1 <= (others => '0');
      basamak2 <= (others => '0');
      basamak3 <= (others => '0'); 
       
   elsif (rising_edge(clk)) then 
      -- basamak1 güncelleme
      case sayac is
         when 0 => basamak1 <= "01000000";
         when 1 => basamak1 <= "01111001";
         when 2 => basamak1 <= "00100100";
         when 3 => basamak1 <= "00110000";
         when 4 => basamak1 <= "00011001";
         when 5 => basamak1 <= "00010010";
         when 6 => basamak1 <= "00000010";
         when 7 => basamak1 <= "01111000";
         when 8 => basamak1 <= "00000000";
         when 9 => basamak1 <= "00010000";
         when others => basamak1 <= (others => '0');
      end case;
      
      -- basamak2 güncelleme
      case sayac2 is
         when 0 => basamak2 <= "01000000";
         when 1 => basamak2 <= "01111001";
         when 2 => basamak2 <= "00100100";
         when 3 => basamak2 <= "00110000";
         when 4 => basamak2 <= "00011001";
         when 5 => basamak2 <= "00010010";
         when 6 => basamak2 <= "00000010";
         when 7 => basamak2 <= "01111000";
         when 8 => basamak2 <= "00000000";
         when 9 => basamak2 <= "00010000";
         when others => basamak2 <= (others => '0');
      end case;
      
      -- basamak3 güncelleme
      case sayac3 is
         when 0 => basamak3 <= "01000000";
         when 1 => basamak3 <= "01111001";
         when 2 => basamak3 <= "00100100";
         when 3 => basamak3 <= "00110000";
         when 4 => basamak3 <= "00011001";
         when 5 => basamak3 <= "00010010";
         when 6 => basamak3 <= "00000010";
         when 7 => basamak3 <= "01111000";
         when 8 => basamak3 <= "00000000";
         when 9 => basamak3 <= "00010000";
         when others => basamak3 <= (others => '0');
      end case;
      
      if(sync_reset = '1') then
         q_reg     <= (others => '0');
         sayac     <= 0;
         sayac2    <= 0;
         sayac3    <= 0;
         cikis     <= '0'; 
         cikis_reg <= '0';
         basamak1 <= (others => '0');
         basamak2 <= (others => '0');
         basamak3 <= (others => '0');
      
      elsif(sync_reset = '0') then 
         if(stop = '0') then
            if (q_reg = 4999999) then -- Normalde 10.000.000 saymak gerektiği çıkıyor hesaplama sonucunda ama wave form'da 4 tane 1 verdiği için ben de sayıyı yarıya düşürerek (5M) her 1 saniyede 10 tane 1 almayı başardım.  
               q_reg <= (others => '0');
               cikis <= '1';  
            
            else
               q_reg <= q_reg + 1;
               cikis <= '0';  
            end if; 
         
         elsif(stop = '1') then
            null;
         end if;
         
      end if;   
      
   end if;
   
   -- Kaç tane 0.1 olduğunu sayma mekanizması
   if(cikis = '1' and cikis_reg = '0' ) then 
      if(sayac < 9) then
         sayac <= sayac + 1;  
      else
         sayac <= 0;
         -- İkinci basamak sayacı bu aralıkta
         if(sayac2 < 9) then
            sayac2 <= sayac2 + 1;
         else
            sayac2 <= 0;
            --üçüncü basamak sayacı
            if(sayac3 < 9) then
               sayac3 <= sayac3 + 1;
            else
               sayac3 <= 0;
            end if;
           --üçüncü basamak sayacı
         end if;
         -- İkinci basamak sayacı bu aralıkta
      end if;
   end if;
   cikis_reg <= cikis;

end process;


-- 7-Segmentler dp,g,f,e,d,c,b,a şeklinde sıralanıyor.

end Behavioral;
