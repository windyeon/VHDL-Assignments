library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;

entity crosswalk_control is
   port(
      nRst  : in std_logic;
      clk   : in std_logic;
      
      man_grn : out std_logic;
      man_red : out std_logic;
      car_red : out std_logic;
      car_yel : out std_logic;
      car_grn : out std_logic;
      
      count   : out std_logic_vector(3 downto 0);
      odd_sig : out std_logic_vector(2 downto 0)
   );
 end crosswalk_control;
 
 architecture BEH of crosswalk_control is
    type state_type is (MAN_GO, MAN_STOP, CAR_GO, CAR_STOP);
    signal state : state_type;
    signal cnt  : std_logic_vector(4 downto 0);
    
    type clk_type is (odd_clk, even_clk);
    signal state2 : clk_type;
   
begin
    process(nRst, clk)
    begin
       if(nRst = '0') then
             state <= MAN_GO;
             cnt <= (others => '0');
          elsif rising_edge(clk) then
          
          case state is
            when MAN_GO =>
            if(cnt = 30)  then
               state <= MAN_STOP;
               cnt <= (others => '0');
            else
               cnt <= cnt + 1;
               man_grn <= '1';
               man_red <= '0';
               car_red <= '1';
               car_yel <= '0';
               car_grn <= '0';
            end if;
            
            when  MAN_STOP =>
            if(cnt = 10)  then
               state <= CAR_GO;
               cnt <= (others => '0');
               
                  if(state2 = even_clk) then
                  man_grn <= '1';
                  elsif (state2 = odd_clk) then
                  man_grn <= '0';
                  else
                  man_grn <= '1';
                  end if;
            else
               cnt <= cnt + 1;
               
                  if(state2 = even_clk) then
                  man_grn <= '1';
                  elsif (state2 = odd_clk) then
                  man_grn <= '0';
                  else
                  man_grn <= '1';
                  end if;
                        
               man_red <= '0';
               car_red <= '1';
               car_yel <= '0';
               car_grn <= '0';
            end if;
            
            when CAR_GO =>
            if(cnt = 60) then
               state <= CAR_STOP;
               cnt <= (others => '0');
            else
               cnt <= cnt + 1;
               man_grn <= '0';
               man_red <= '1';
               car_red <= '0';
               car_yel <= '0';
               car_grn <= '1';
            end if;
            
            
            when CAR_STOP =>
            if(cnt = 5) then
               state <= MAN_GO;
               cnt <= (others => '0');
            else
               cnt <= cnt + 1;
               man_grn <= '0';
               man_red <= '1';
               car_red <= '0';
               car_yel <= '1';
               car_grn <= '0';
            end if;
            
            when others =>
            state <= MAN_GO;
         
         end case;
         
         case state2 is
         when even_clk =>
         state2 <= odd_clk;
         when odd_clk =>
         state2 <= even_clk;
         when others =>
         state2 <= even_clk;
         
         end case;
         
      end if;
   end process;
   
odd_sig <= "000" when state2 = even_clk else
           "001" when state2 = odd_clk else
           "000";
        
end BEH;