library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity FIFO_Controler_circuit is
  Generic(
     ADDR_WIDTH : natural := 2
  );
  
  Port (
     clk            : in std_logic;
     reset          : in std_logic;
     rd, wr         : in std_logic;
     empty, full    : out std_logic;
     w_addr, r_addr : out std_logic_vector(ADDR_WIDTH -1 downto 0)
  
   );
end FIFO_Controler_circuit;

architecture Behavioral of FIFO_Controler_circuit is
   signal w_ptr_reg, w_ptr_next, w_ptr_succ : std_logic_vector(ADDR_WIDTH - 1 downto 0); 
   signal r_ptr_reg, r_ptr_next, r_ptr_succ : std_logic_vector(ADDR_WIDTH - 1 downto 0); 
   signal empty_reg, empty_next             : std_logic;
   signal full_reg, full_next               : std_logic;
   signal wr_op                             : std_logic_vector(1 downto 0);
begin


process(clk, reset)
begin

   if(reset = '1') then
      w_ptr_reg <= (others => '0');
      r_ptr_reg <= (others => '0');
      full_reg  <= '0';
      empty_reg <= '1';
      
   elsif(clk'event and clk = '1') then
      w_ptr_reg <= w_ptr_next;
      r_ptr_reg <= r_ptr_next;
      full_reg  <= full_next;
      empty_reg <= empty_next;
   end if;
   
end process;

w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg) + 1);
r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg) + 1);

wr_op <= wr & rd;

process(w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, wr_op, empty_reg, full_reg)
begin
   
   w_ptr_next <= w_ptr_reg;
   r_ptr_next <= r_ptr_reg;
   full_next  <= full_reg;
   empty_next <= empty_reg;
   
   
   case wr_op is
      when "00" =>  -- no op.
      when "01" =>  -- only read 
         if(empty_reg /= '1') then -- not empty
            r_ptr_next <= r_ptr_succ; -- neden reg neðil de next deðerine atadik ki bunu þimdi?
            full_next <= '0';
            
            if(r_ptr_succ = w_ptr_reg) then
               empty_next <= '1';
            end if;
         end if;
         
      when "10" => -- only write
         if(full_reg /= '1') then -- not full
            w_ptr_next <= w_ptr_succ; -- bir sonraki durumun hesaplanmýþ deðeri eðer koþul saðlanýyorsa next durumuna veriliyor. üstteki sorunun cevabý olabilir bu. 
            empty_next <= '0';
            
            if(w_ptr_succ = r_ptr_reg) then
               full_next <= '1';
            end if;
         end if;
         
      when others =>  -- write/read
         w_ptr_next <= w_ptr_succ;
         r_ptr_next <= r_ptr_succ;
   end case;

end process;

w_addr <= w_ptr_reg;
r_addr <= r_ptr_reg;
full  <= full_reg;
empty <= empty_reg;

end Behavioral;
