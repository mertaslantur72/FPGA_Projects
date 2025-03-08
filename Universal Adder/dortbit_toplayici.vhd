--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;


--entity add_w_carry is
--  Port (
--  a : in std_logic_vector(3 downto 0);
--  b : in std_logic_vector(3 downto 0);
--  cout : out std_logic;
--  sum : out std_logic_vector(3 downto 0)
--  );
--end add_w_carry;



--architecture Behavioral of add_w_carry is
--signal a_ext, b_ext, sum_ext : unsigned(4 downto 0);
--begin

--a_ext <= unsigned('0' & a);
--b_ext <= unsigned('0' & b);
--sum_ext <= a_ext + b_ext;
--sum <= std_logic_vector(sum_ext(3 downto 0));
--cout <= sum_ext(4);

--end Behavioral;

---- Constant içeren ve deðiþebilen kod, toplayýcý:
---- Constant içerrince daha anlaþýlýr oluyormuþ güya...

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;


--entity add_w_carry is
--  Port (
--  a : in std_logic_vector(3 downto 0);
--  b : in std_logic_vector(3 downto 0);
--  cout : out std_logic;
--  sum : out std_logic_vector(3 downto 0)
--  );
--end add_w_carry;



--architecture Behavioral of add_w_carry is
--constant N : integer :=4;
--signal a_ext, b_ext, sum_ext : unsigned(N downto 0);
--begin

--a_ext <= unsigned('0' & a);
--b_ext <= unsigned('0' & b);
--sum_ext <= a_ext + b_ext;
--sum <= std_logic_vector(sum_ext(N-1 downto 0));
--cout <= sum_ext(N);

--end Behavioral;

-- Burada da generic kýsmý var. Generic tanýmladýðýmýz þeyi
--ileride deðiþtirmeye olanak saðlarken constant ise
-- tanýmladýðýmýz sabiti kodun geri kalanýnda aynen kullanmnak
--içindir. yani deðer deðiþmez, hep aynýdýr.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_add_w_carry is

generic(N : integer :=64);
port(
a : in std_logic_vector(N-1 downto 0);
b : in std_logic_vector(N-1 downto 0);
cout : out std_logic;
sum : out std_logic_vector(N-1 downto 0)
);

end gen_add_w_carry;


architecture Behavioral of gen_add_w_carry is
signal a_ext, b_ext, sum_ext : unsigned(N downto 0);
begin

a_ext <= unsigned('0' & a);
b_ext <= unsigned('0' & b);
sum_ext <= a_ext + b_ext;
sum <= std_logic_vector(sum_ext(N-1 downto 0));
cout <= sum_ext(N);

end Behavioral;





