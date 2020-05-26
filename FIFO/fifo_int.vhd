library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity fifo_int is
  generic(
    size      : natural;
    datawidth : natural
  );
  port (
   reset_n : in  std_logic;
   clk     : in  std_logic;
   sreset  : in  std_logic;
   push    : in  std_logic;
   datain  : in  signed(datawidth-1 downto 0);
   pop     : in  std_logic;
   dataout : out signed(datawidth-1 downto 0);
   empty   : out std_logic;
   full    : out std_logic;
   level   : out integer range -1 to size
  );
end entity;

architecture rtl of fifo_int is
  type regs_t is array(0 to size-1) of signed(datawidth-1 downto 0);
  signal regs : regs_t;
  signal addr : integer range -1 to size;
begin

  regs_p : process(reset_n,clk)
    variable wr_rd : std_logic_vector(1 downto 0);
  begin
    if reset_n='0' then
      for i in 0 to size-1 loop
        regs(i) <= to_signed(0,datawidth);
      end loop;
      addr <= 0;
    elsif rising_edge(clk) then
      if sreset='1' then
        for i in 0 to size-1 loop
          regs(i) <= to_signed(0,datawidth);
        end loop;
        addr <= 0;
      else
        wr_rd:= push & pop;
        case wr_rd is
          when "10" =>
            if addr < size then
              regs(addr) <= datain;
              addr <= addr + 1;
            end if;
          when "11" =>
            regs(addr) <= datain;
          when "01" =>
            for i in size-1 downto 1 loop
              regs(i-1) <= regs(i);
            end loop;
            if addr > 0 then
              addr <= addr-1;
            end if;
          when others =>
            null;
        end case;
      end if;
    end if;
  end process;

  full   <= '1' when addr=size     else '0';
  empty  <= '1' when addr=0        else '0';
  level  <= addr;
  dataout <= regs(0);

end architecture;
