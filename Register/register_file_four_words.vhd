--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity register_file_four_words is
--  Port (
--  clk : in std_logic;
--  wr_en : in std_logic; -- Yazma izni
--  w_addr : in std_logic_vector(1 downto 0); -- Yazma adresi se�ici
--  r_addr : in std_logic_vector(1 downto 0); -- Okuma adresi se�ici
--  w_data : in std_logic_vector(7 downto 0); -- yaz�lacak veri
--  r_data : out std_logic_vector(7 downto 0) -- okunan veri
  
--   );
--end register_file_four_words;
---- DATA_WIDTH, bir kelimedeki bit say�s�n� ifade ediyor. ADDR_WIDTH ise ades biti say�s�n� ifade ediyor.
--architecture Behavioral of register_file_four_words is
--  constant ADDR_WIDTH : natural := 2; -- natural t�pk� integer gibi say� tipidir. Tek fark� sadece pozitif de�erler alabiliyor olu�udur. integer negatif de�erler de alabilir.
--  constant DATA_WIDTH : natural := 8; --bits in data. Bu sabitleri tan�mlamaktaki ama� tamam�yla mod�lerlik. Yani biz adres gen.=3 dedi�imiz anda koddaki di�er de�erlere dokunmadan adres geni�li�i ile ilgili olan her �ey an�nda 3 �zerinden i�lem g�recek.
--  -- Ve register say�m�z 8'e ��kacak. Tabii 8 registerlik bir register dosayas�ne evirmek i�in bu dosyay�, sabitleri de�i�mek yetmez. Giri�lerdeki yazma ve okuma bit de�erleri de g�ncellenmelidir.
--  type mem_2d_type is array(0 to 2**ADDR_WIDTH -1) of std_logic_vector(DATA_WIDTH-1 downto 0); --Burada bir dizi olu�turuyoruz ve dizinin her bir eleman� 8 bitlik veri (1 adet register yani) tutuyor.
--  -- de�i�kenimizin isim a��klamas� da (muhtemelen) "memory 2-dimension type" d�r. San�r�m VHDL'de 2 boyutlu dizi olmad��� i�in yeni bir de�i�ken t�r�nde tan�mlad�k biz onu.
--  signal array_reg : mem_2d_type;-- Bu da yukar�da type'�n� olu�turdu�umuz de�i�ken t�r�nde bir de�i�ken. [-- -- -- --] g�rseldeki gibi 4 register bar�nd�ran bir 2D dizi.
--  signal en : std_logic_vector(2**ADDR_WIDTH-1 downto 0); -- hangi register'�n yaz�laca��n� belirler. Kullanmasak da olacakm�� gibi duruyor bence. Ama GPT optimizasyon i�in ve gelecekteki modulerlik ad�na olmas� gereken ve s�k�a kullan�lan bir sinyal dedi. O y�zden bula�mad�m.

--begin

---- 4 Register
--process(clk)
--begin

--   if(clk'event and clk = '1') then
--      if(en(3) = '1') then
--         array_reg(3) <= w_data;
--      end if;
--      if(en(2) = '1') then
--         array_reg(2) <= w_data;
--      end if;
--      if(en(1) = '1') then
--         array_reg(1) <= w_data;
--      end if;
--      if(en(0) = '1') then
--         array_reg(0) <= w_data;
--      end if;
--   end if;
   
--end process;

---- Decoding logic for write address
--process(wr_en, w_addr)
--begin

--   if(wr_en = '0') then
--      en <= (others => '0');
--   else
--      case w_addr is
--         when "00" => en <= "0001"; -- w_addr 00 oldu�unda en 0001 olsun demek
--         when "01" => en <= "0010";
--         when "10" => en <= "0100";
--         when others => en <= "1000";
--      end case;
--   end if;

--end process;

---- Read multiplexing
--with r_addr select r_data <=
--   array_reg(0) when "00",
--   array_reg(1) when "01",
--   array_reg(2) when "10",
--   array_reg(3) when others;

--end Behavioral;
---- Yukar�daki kod e�er register say�s� artarsa (ki artacak) case ya da with select ya da if yap�lar�yla her durumu ifade etmek �ok k�lfetli ve hantalca olaca�� i�in
---- Dynamic array indexing operation ad�nda yeni ve daha az yer kaplayan, g�rece daha kolay bir kod yaz�m�yla ayn� i�elmi yapaca��z. 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dyn_arry_indx is
  generic(
     ADDR_WIDTH : integer := 2;
     DATA_WIDTH : integer := 8
  );
  
  port(
     clk : in std_logic;
     wr_en  : in std_logic;
     w_addr : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     r_addr : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
     w_data : in std_logic_vector(DATA_WIDTH - 1 downto 0);
     r_data : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end dyn_arry_indx;
-- Dikkatini �ekerim, ilk koddaki sabitleri burada architecture'de de�il de entity'de generic olarak yazd�. Universal yapt� yani kodu. Ayr�ca �imdi bu de�erler de�i�tiinde
-- entity i�erisindeki giri� ��k��larda an�nda g�ncellenecek (extra u�ra�a gerek kalmayacak).
architecture behavioral of dyn_arry_indx is
   type mem_2d_type is array(0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
   signal array_reg : mem_2d_type;
   
begin

process(clk)
begin

   if(clk'event and clk = '1') then
      if(wr_en = '1') then
         array_reg(to_integer(unsigned(w_addr))) <= w_data; -- Bu d�n���m �nemli. Tek sat�rda s*kti att� hepsini. Asl�nda burada benim ilk kodda en sinyalini iptal etme fikrimi ger�ekle�tiriyor bir bak�ma.
         -- ��nk� bu sat�rda �u oluyor: w_addr diyelim ki 00 de�erinde. Bunu integer'e �evirip 2 boyutlu diziye indekx/integer olarak yaz�yo. Bu sayede case ya da select yap�lar�na ihtiya� duymuyoruz.
      end if;
   end if;

end process;

-- Read port
r_data <= array_reg(to_integer(unsigned(r_addr))); -- Yazmada ne oluyorsa ayn�s�. Ayn� c�mleler bunun i�in de ge�erli.
end behavioral;