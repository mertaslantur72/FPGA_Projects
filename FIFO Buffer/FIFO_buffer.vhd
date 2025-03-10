library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity FIFO_buffer is
   Generic(
      ADDR_WIDTH : NATURAL :=2;
      DATA_WIDTH : NATURAL :=8
   );

  Port (
     clk, reset  : in std_logic;
     rd, wr      : in std_logic;
     w_data      : in std_logic_vector(DATA_WIDTH -1 downto 0);
     empty, full : out std_logic;
     r_data      :out std_logic_vector(DATA_WIDTH -1 downto 0)
   );
end FIFO_buffer;

architecture Behavioral of FIFO_buffer is
   signal full_tmp : std_logic;
   signal wr_en : std_logic;
   signal w_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
   signal r_addr : std_logic_vector(ADDR_WIDTH - 1 downto 0);
   
begin
   -- write enabled only when fýfý is not full
   wr_en <= wr and (not full_tmp);
   full <= full_tmp ;
  
   --instantiate fýfo ctr unit
   ctrl_unit : entity work.FIFO_Controler_circuit(Behavioral)
      Generic map(
         ADDR_WIDTH => ADDR_WIDTH
      )
      
      Port map(
         clk    => clk,
         reset  => reset,
         rd     => rd,
         wr     => wr,
         empty  => empty,
         full   => full_tmp,
         w_addr => w_addr,
         r_addr => r_addr
      );
      
      -- Instantiate register file
      reg_file_unit : entity work.register_file(Behavioral)
         Generic map(
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
         )
         
         Port map(
            clk  => clk,
            w_addr => w_addr,
            r_addr => r_addr,
            w_data => w_data,
            r_data => r_data,
            wr_en => wr_en
         );
   
end Behavioral;
