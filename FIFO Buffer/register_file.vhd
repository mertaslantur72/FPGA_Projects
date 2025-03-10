library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.All;

entity register_file is
  generic(
     ADDR_WIDTH : natural := 2;
     DATA_WIDTH : natural := 8
  );
  
  Port (
     clk     : in std_logic;
     wr_en   : in std_logic;
     w_addr  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     r_addr  : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
     w_data  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
     r_data  : out std_logic_vector(DATA_WIDTH - 1 downto 0)
   );
end register_file;

architecture Behavioral of register_file is
   type mem_2d_type is array(0 to 2**ADDR_WIDTH -1) of std_logic_vector(DATA_WIDTH - 1 downto 0); 
   signal array_reg : mem_2d_type; -- 2 Dimension array. Each element of array is an 8 bit register(data).
begin

process(clk)
begin
   -- Write Data
   if(clk'event and clk = '1') then
      if(wr_en = '1') then
         array_reg(to_integer(unsigned(w_addr))) <= w_data;
      end if;
   end if;

end process;
-- Read Data
r_data <= array_reg(to_integer(unsigned(r_addr)));
end Behavioral;
