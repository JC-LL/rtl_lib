-----------------------------------------------------------------
-- This file was generated automatically by Vertigo Ruby utility
-- date : (d/m/y) 07/05/2020 18:37
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fifo_int_tb is
end entity;

architecture bhv of fifo_int_tb is

  constant HALF_PERIOD : time := 5 ns;

  constant datawidth : natural := 8;
  constant size      : natural := 10;

  signal clk : std_logic := '0';
  signal reset_n : std_logic := '0';

  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

  signal sreset    : std_logic;
  signal push    : std_logic;
  signal datain  : signed(datawidth - 1 downto 0);
  signal pop     : std_logic;
  signal dataout : signed(datawidth - 1 downto 0);
  signal empty   : std_logic;
  signal full    : std_logic;
begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0','1' after 66 ns;
  sreset  <= '0';
  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.fifo_int(rtl)
        generic map(
          size      => SIZE,
          datawidth => datawidth
        )
        port map (
	        reset_n => reset_n,
	        clk => clk,
          sreset => sreset,
	        push => push,
	        datain => datain,
	        pop => pop,
	        dataout => dataout,
          empty => empty,
          full  => full
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process

    procedure cmd_push(x : integer) is
    begin
      push    <= '1';
      datain  <= to_signed(x,datawidth);
      wait until rising_edge(clk);
      push    <= '0';
      wait until rising_edge(clk);
    end procedure;

    procedure cmd_pop is
    begin
      pop    <= '1';
      wait until rising_edge(clk);
      pop    <= '0';
      wait until rising_edge(clk);
    end procedure;

   begin
     push <= '0';
     pop  <= '0';
     report "running testbench for fifo_int(arch)";
     report "waiting for asynchronous reset";
     wait until reset_n='1';
     wait_cycles(10);
     report "applying stimuli...";
     for j in 0 to 10 loop
       for i in 0 to size+3 loop
         cmd_push(i);
       end loop;
       for i in 0 to size+3 loop
         cmd_pop;
       end loop;
    end loop;

     wait_cycles(10);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
