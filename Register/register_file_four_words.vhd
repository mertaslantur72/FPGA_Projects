--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity register_file_four_words is
--  Port (
--  clk : in std_logic;
--  wr_en : in std_logic; -- Yazma izni
--  w_addr : in std_logic_vector(1 downto 0); -- Yazma adresi seçici
--  r_addr : in std_logic_vector(1 downto 0); -- Okuma adresi seçici
--  w_data : in std_logic_vector(7 downto 0); -- yazýlacak veri
--  r_data : out std_logic_vector(7 downto 0) -- okunan veri
  
--   );
--end register_file_four_words;
---- DATA_WIDTH, bir kelimedeki bit sayýsýný ifade ediyor. ADDR_WIDTH ise ades biti sayýsýný ifade ediyor.
--architecture Behavioral of register_file_four_words is
--  constant ADDR_WIDTH : natural := 2; -- natural týpký integer gibi sayý tipidir. Tek farký sadece pozitif deðerler alabiliyor oluþudur. integer negatif deðerler de alabilir.
--  constant DATA_WIDTH : natural := 8; --bits in data. Bu sabitleri tanýmlamaktaki amaç tamamýyla modülerlik. Yani biz adres gen.=3 dediðimiz anda koddaki diðer deðerlere dokunmadan adres geniþliði ile ilgili olan her þey anýnda 3 üzerinden iþlem görecek.
--  -- Ve register sayýmýz 8'e çýkacak. Tabii 8 registerlik bir register dosayasýne evirmek için bu dosyayý, sabitleri deðiþmek yetmez. Giriþlerdeki yazma ve okuma bit deðerleri de güncellenmelidir.
--  type mem_2d_type is array(0 to 2**ADDR_WIDTH -1) of std_logic_vector(DATA_WIDTH-1 downto 0); --Burada bir dizi oluþturuyoruz ve dizinin her bir elemaný 8 bitlik veri (1 adet register yani) tutuyor.
--  -- deðiþkenimizin isim açýklamasý da (muhtemelen) "memory 2-dimension type" dýr. Sanýrým VHDL'de 2 boyutlu dizi olmadýðý için yeni bir deðiþken türünde tanýmladýk biz onu.
--  signal array_reg : mem_2d_type;-- Bu da yukarýda type'ýný oluþturduðumuz deðiþken türünde bir deðiþken. [-- -- -- --] görseldeki gibi 4 register barýndýran bir 2D dizi.
--  signal en : std_logic_vector(2**ADDR_WIDTH-1 downto 0); -- hangi register'ýn yazýlacaðýný belirler. Kullanmasak da olacakmýþ gibi duruyor bence. Ama GPT optimizasyon için ve gelecekteki modulerlik adýna olmasý gereken ve sýkça kullanýlan bir sinyal dedi. O yüzden bulaþmadým.

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
--         when "00" => en <= "0001"; -- w_addr 00 olduðunda en 0001 olsun demek
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
---- Yukarýdaki kod eðer register sayýsý artarsa (ki artacak) case ya da with select ya da if yapýlarýyla her durumu ifade etmek çok külfetli ve hantalca olacaðý için
---- Dynamic array indexing operation adýnda yeni ve daha az yer kaplayan, görece daha kolay bir kod yazýmýyla ayný iþelmi yapacaðýz. 

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
-- Dikkatini çekerim, ilk koddaki sabitleri burada architecture'de deðil de entity'de generic olarak yazdý. Universal yaptý yani kodu. Ayrýca þimdi bu deðerler deðiþtiinde
-- entity içerisindeki giriþ çýkýþlarda anýnda güncellenecek (extra uðraþa gerek kalmayacak).
architecture behavioral of dyn_arry_indx is
   type mem_2d_type is array(0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
   signal array_reg : mem_2d_type;
   
begin

process(clk)
begin

   if(clk'event and clk = '1') then
      if(wr_en = '1') then
         array_reg(to_integer(unsigned(w_addr))) <= w_data; -- Bu dönüþüm önemli. Tek satýrda s*kti attý hepsini. Aslýnda burada benim ilk kodda en sinyalini iptal etme fikrimi gerçekleþtiriyor bir bakýma.
         -- Çünkü bu satýrda þu oluyor: w_addr diyelim ki 00 deðerinde. Bunu integer'e çevirip 2 boyutlu diziye indekx/integer olarak yazýyo. Bu sayede case ya da select yapýlarýna ihtiyaç duymuyoruz.
      end if;
   end if;

end process;

-- Read port
r_data <= array_reg(to_integer(unsigned(r_addr))); -- Yazmada ne oluyorsa aynýsý. Ayný cümleler bunun için de geçerli.
end behavioral;