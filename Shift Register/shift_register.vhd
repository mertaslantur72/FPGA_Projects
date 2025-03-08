library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shift_register is
  generic(N: integer := 8);
  Port (
     clk : in std_logic;
     reset : in std_logic;
     giris : in std_logic_vector(N-1 downto 0);
     ctrl  : in std_logic;
     cikis : out std_logic_vector(N-1 downto 0)
   );
end shift_register;

architecture Behavioral of shift_register is
signal tutucu : std_logic_vector(N-1 downto 0);

begin

process(clk, reset)
begin

   if(reset = '1') then
      tutucu <= giris;
  
   elsif(clk'event and clk = '1') then
      if(ctrl = '0') then
         tutucu <= tutucu(N-2 downto 0) & '0';
      
      elsif(ctrl = '1') then
         tutucu <= '0' & tutucu(N-1 downto 1);
         
      else
         tutucu <= giris;
      end if;
   end if;
end process;
cikis <= tutucu;
end Behavioral;
