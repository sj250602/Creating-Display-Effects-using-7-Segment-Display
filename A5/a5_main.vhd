----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2022 10:45:22 AM
-- Design Name: 
-- Module Name: a5_main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity a5_main is  -- make a entity with name as a4
 Port ( clk : in  std_logic; --define a clock
        segment : out std_logic_vector(6 downto 0); --define a vector of length 7 that contains output of 7 segment display
        anode : out std_logic_vector(3 downto 0); -- define a vector of size 4 for the 4 seven segment display
        button_d : in std_logic; -- define a push down button for brightness
        button_b : in  std_logic; -- define a push down button for digit
        switches : in std_logic_vector(15 downto 0));--define a vector of length 16 that contains input 4 length for each display
end a5_main;

architecture Behavioral of a5_main is
signal Bt : std_logic_vector(3 downto 0):="0000"; --define a signal for handle the input given by the buttons
signal refresh_clk : std_logic_vector (19 downto 0):= (others =>'0'); -- a 20-bit clock used for selecting anode and incrementing refresh-rates.
signal refresh_rate : integer :=0; --define an integer for apply the timer to the clock 
signal clk_input : std_logic_vector(1 downto 0):="00"; -- define a signal of size 2-bit for selecting a anode.
signal rotation_counter : integer:=0; -- define a counter for rotating the digit
signal digit_sig : std_logic_vector(15 downto 0); --define a vector of length 16 that contains input 4 length for each display
signal bright_sig : std_logic_vector(7 downto 0); --define a vector of length 8 that tells the controls on the brightness
signal brightness : std_logic_vector(1 downto 0); -- define a vector of length 2 for tells the anode we need to glow with how much brightness
signal bl1 : integer := 0; -- define a interger taht basically check the brightness range 1
signal bl2 : integer := 0; -- define a interger taht basically check the brightness range 2
signal bl3 : integer := 0; -- define a interger taht basically check the brightness range 3
signal bl4 : integer := 0; -- define a interger taht basically check the brightness range 4
signal temp_b1 : integer := 0; 
signal temp_b2 : integer := 0;
signal temp_b3 : integer := 0;
signal temp_b4 : integer := 0;
signal state : integer := 0; -- define a state for controls the brightness
signal state_counter : integer := 0; -- define a counter that basically increase on a rising clock
signal anode_sig : std_logic_vector(3 downto 0):="1110"; -- define a anode signal that basically show which anode need to glow
begin
-- define a process over the 2 buttons that cotrols the dgits needs to show and the brightness
process(button_b,button_d)
begin
    if rising_edge(clk) then
        if button_d = '1' then
            digit_sig <= switches;
        end if ;
        if button_b = '1' then
            bright_sig <= switches(7 downto 0);
        end if ;
    end if;
end process;

-- Define a process of a combinational circuit using the logical expressions for each output segment
process(Bt)
begin
segment(0) <= (not Bt(3) and not Bt(2) and not Bt(1) and Bt(0)) or(not Bt(3) and Bt(2) and not Bt(1) and not Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and not Bt(2) and Bt(1) and Bt(0));
segment(1) <= (Bt(2) and Bt(1) and not Bt(0)) or (Bt(3) and Bt(1) and Bt(0)) or (not Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and not Bt(0));
segment(2) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(3) AND Bt(2) AND Bt(1)) OR (Bt(3) AND Bt(2) AND (NOT Bt(0)));
segment(3) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0))) OR (Bt(3) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(2) AND Bt(1) AND Bt(0));
segment(4) <= ((NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)));
segment(5) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(0)) OR ((NOT Bt(3)) AND (NOT Bt(2)) AND (Bt(1))) OR ((NOT Bt(3)) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND Bt(0));
segment(6) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1))) OR ((NOT Bt(3)) AND Bt(2) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0)));

end process;


-- process(clk)
-- begin 
-- if rising_edge(clk) then
--     refresh_clk <= refresh_clk + '1';
--     refresh_rate <= refresh_rate + 1;
--     clk_input <= refresh_clk(19 downto 18);
-- end if ;
-- end process;

-- define a process over clock for rotating the digits after a fixed time 
process(clk)
begin
    if rising_edge(clk) then
        rotation_counter <= rotation_counter + 1;
        state_counter <= state_counter + 1;
        if rotation_counter = bl1 and anode_sig = "1110" then
            rotation_counter <= 0;
            anode_sig <= "1101";
            -- bl4<=bl1;
        elsif rotation_counter = bl2 and anode_sig = "1101" then
            rotation_counter <= 0;
            anode_sig <= "1011";
            -- bl3<=bl4;
        elsif rotation_counter = bl3 and anode_sig = "1011" then
            rotation_counter <= 0;
            anode_sig <= "0111";
            -- bl2<=bl3;
        elsif rotation_counter = bl4 and anode_sig = "0111" then
            rotation_counter <= 0;
            anode_sig <= "1110";
            -- bl1<=bl2;
        end if ;
        
        if state_counter = 100000000 then
            state_counter <=0;
            if state <3 then
                state <= state + 1;
            else
                state<=0;    
            end if ;
        end if ;
    end if ;
end process;

-- define a process over anode signal for control the brightness of the digits and rotate the brightness with the digits
process(anode_sig)
begin
    if anode_sig = "0111" then
        brightness <= bright_sig(7 downto 6);
        
        if brightness = "00"then
            temp_b1 <= 6250;
        elsif brightness = "01" then
            temp_b1 <= 12500;
        elsif brightness = "10" then
            temp_b1<=50000;
        else
            temp_b1 <= 100000;
        end if;


        if state = 0 and brightness = "00" then
            Bt<=digit_sig(3 downto 0);
            bl1<=temp_b4;
        elsif state = 0 and brightness = "01" then
            Bt<=digit_sig(3 downto 0);
            bl1<=temp_b4;
        elsif state = 0 and brightness = "10" then
            Bt<=digit_sig(3 downto 0);
            bl1<=temp_b4;
        elsif state = 0 and brightness = "11" then
            Bt<=digit_sig(3 downto 0);
            bl1<=temp_b4;
        


            
        elsif state = 1 and brightness = "00" then
            Bt<=digit_sig(7 downto 4);
            bl1<=temp_b3;
        elsif state = 1 and brightness = "01" then
            Bt<=digit_sig(7 downto 4);
            bl1<=temp_b3;
        elsif state = 1 and brightness = "10" then
            Bt<=digit_sig(7 downto 4);
            bl1<=temp_b3;
        elsif state = 1 and brightness = "11" then
            Bt<=digit_sig(7 downto 4);
            bl1<=temp_b3;
        
        
        elsif state = 2 and brightness = "00" then
            Bt<=digit_sig(11 downto 8);
            bl1<=temp_b2;
        elsif state = 2 and brightness = "01" then
            Bt<=digit_sig(11 downto 8);
            bl1<=temp_b2;
        elsif state = 2 and brightness = "10" then
            Bt<=digit_sig(11 downto 8);
            bl1<=temp_b2;
        elsif state = 2 and brightness = "11" then
            Bt<=digit_sig(11 downto 8);
            bl1<=temp_b2;
        

        elsif state = 3 and brightness = "00" then
            Bt<=digit_sig(15 downto 12);
            bl1<=temp_b1;
        elsif state = 3 and brightness = "01" then
            Bt<=digit_sig(15 downto 12);
            bl1<=temp_b1;
        elsif state = 3 and brightness = "10" then
            Bt<=digit_sig(15 downto 12);
            bl1<=temp_b1;
        elsif state = 3 and brightness = "11" then
            Bt<=digit_sig(15 downto 12);
            bl1<=temp_b1;
        end if ;
        anode <= "0111";


    elsif anode_sig = "1011" then
        brightness <= bright_sig(5 downto 4);

        if brightness = "00"then
            temp_b2 <= 6250;
        elsif brightness = "01" then
            temp_b2 <= 12500;
        elsif brightness = "10" then
            temp_b2<=50000;
        else
            temp_b2 <= 100000;
        end if;


        if state = 0 and brightness = "00" then
            Bt<=digit_sig(7 downto 4);
            bl2<=temp_b3;
        elsif state = 0 and brightness = "01" then
            Bt<=digit_sig(7 downto 4);
            bl2<=temp_b3;
        elsif state = 0 and brightness = "10" then
            Bt<=digit_sig(7 downto 4);
            bl2<=temp_b3;
        elsif state = 0 and brightness = "11" then
            Bt<=digit_sig(7 downto 4);
            bl2<=temp_b3;
        


            
        elsif state = 1 and brightness = "00" then
            Bt<=digit_sig(11 downto 8);
            bl2<=temp_b2;
        elsif state = 1 and brightness = "01" then
            Bt<=digit_sig(11 downto 8);
            bl2<=temp_b2;
        elsif state = 1 and brightness = "10" then
            Bt<=digit_sig(11 downto 8);
            bl2<=temp_b2;
        elsif state = 1 and brightness = "11" then
            Bt<=digit_sig(11 downto 8);
            bl2<=temp_b2;
        
        
        elsif state = 2 and brightness = "00" then
            Bt<=digit_sig(15 downto 12);
            bl2<=temp_b1;
        elsif state = 2 and brightness = "01" then
            Bt<=digit_sig(15 downto 12);
            bl2<=temp_b1;
        elsif state = 2 and brightness = "10" then
            Bt<=digit_sig(15 downto 12);
            bl2<=temp_b1;
        elsif state = 2 and brightness = "11" then
            Bt<=digit_sig(15 downto 12);
            bl2<=temp_b1;
        

        elsif state = 3 and brightness = "00" then
            Bt<=digit_sig(3 downto 0);
            bl2<=temp_b4;
        elsif state = 3 and brightness = "01" then
            Bt<=digit_sig(3 downto 0);
            bl2<=temp_b4;
        elsif state = 3 and brightness = "10" then
            Bt<=digit_sig(3 downto 0);
            bl2<=temp_b4;
        elsif state = 3 and brightness = "11" then
            Bt<=digit_sig(3 downto 0);
            bl2<=temp_b4;
        end if ;
        anode <= "1011";


    elsif anode_sig = "1101" then
        brightness <= bright_sig(3 downto 2);
        if brightness = "00"then
            temp_b3 <= 6250;
        elsif brightness = "01" then
            temp_b3 <= 12500;
        elsif brightness = "10" then
            temp_b3<=50000;
        else
            temp_b3 <= 100000;
        end if;

        if state = 0 and brightness = "00" then
            Bt<=digit_sig(11 downto 8);
            bl3<=temp_b2;
        elsif state = 0 and brightness = "01" then
            Bt<=digit_sig(11 downto 8);
            bl3<=temp_b2;
        elsif state = 0 and brightness = "10" then
            Bt<=digit_sig(11 downto 8);
            bl3<=temp_b2;
        elsif state = 0 and brightness = "11" then
            Bt<=digit_sig(11 downto 8);
            bl3<=temp_b2;
        


            
        elsif state = 1 and brightness = "00" then
            Bt<=digit_sig(15 downto 12);
            bl3<=temp_b1;
        elsif state = 1 and brightness = "01" then
            Bt<=digit_sig(15 downto 12);
            bl3<=temp_b1;
        elsif state = 1 and brightness = "10" then
            Bt<=digit_sig(15 downto 12);
            bl3<=temp_b1;
        elsif state = 1 and brightness = "11" then
            Bt<=digit_sig(15 downto 12);
            bl3<=temp_b1;
        
        
        elsif state = 2 and brightness = "00" then
            Bt<=digit_sig(3 downto 0);
            bl3<=temp_b4;
        elsif state = 2 and brightness = "01" then
            Bt<=digit_sig(3 downto 0);
            bl3<=temp_b4;
        elsif state = 2 and brightness = "10" then
            Bt<=digit_sig(3 downto 0);
            bl3<=temp_b4;
        elsif state = 2 and brightness = "11" then
            Bt<=digit_sig(3 downto 0);
            bl3<=temp_b4;
        

        elsif state = 3 and brightness = "00" then
            Bt<=digit_sig(7 downto 4);
            bl3<=temp_b3;
        elsif state = 3 and brightness = "01" then
            Bt<=digit_sig(7 downto 4);
            bl3<=temp_b3;
        elsif state = 3 and brightness = "10" then
            Bt<=digit_sig(7 downto 4);
            bl3<=temp_b3;
        elsif state = 3 and brightness = "11" then
            Bt<=digit_sig(7 downto 4);
            bl3<=temp_b3;
        end if ;
        anode <= "1101";


    elsif anode_sig = "1110" then
        brightness <= bright_sig(1 downto 0);
        if brightness = "00"then
            temp_b4 <= 6250;
        elsif brightness = "01" then
            temp_b4 <= 12500;
        elsif brightness = "10" then
            temp_b4<=50000;
        else
            temp_b4 <= 100000;
        end if;

        if state = 0 and brightness = "00" then
            Bt<=digit_sig(15 downto 12);
            bl4<=temp_b1;
        elsif state = 0 and brightness = "01" then
            Bt<=digit_sig(15 downto 12);
            bl4<=temp_b1;
        elsif state = 0 and brightness = "10" then
            Bt<=digit_sig(15 downto 12);
            bl4<=temp_b1;
        elsif state = 0 and brightness = "11" then
            Bt<=digit_sig(15 downto 12);
            bl4<=temp_b1;
        


            
        elsif state = 1 and brightness = "00" then
            Bt<=digit_sig(3 downto 0);
            bl4<=temp_b4;
        elsif state = 1 and brightness = "01" then
            Bt<=digit_sig(3 downto 0);
            bl4<=temp_b4;
        elsif state = 1 and brightness = "10" then
            Bt<=digit_sig(3 downto 0);
            bl4<=temp_b4;
        elsif state = 1 and brightness = "11" then
            Bt<=digit_sig(3 downto 0);
            bl4<=temp_b4;
        
        
        elsif state = 2 and brightness = "00" then
            Bt<=digit_sig(7 downto 4);
            bl4<=temp_b3;
        elsif state = 2 and brightness = "01" then
            Bt<=digit_sig(7 downto 4);
            bl4<=temp_b3;
        elsif state = 2 and brightness = "10" then
            Bt<=digit_sig(7 downto 4);
            bl4<=temp_b3;
        elsif state = 2 and brightness = "11" then
            Bt<=digit_sig(7 downto 4);
            bl4<=temp_b3;
        

        elsif state = 3 and brightness = "00" then
            Bt<=digit_sig(11 downto 8);
            bl4<=temp_b2;
        elsif state = 3 and brightness = "01" then
            Bt<=digit_sig(11 downto 8);
            bl4<=temp_b2;
        elsif state = 3 and brightness = "10" then
            Bt<=digit_sig(11 downto 8);
            bl4<=temp_b2;
        elsif state = 3 and brightness = "11" then
            Bt<=digit_sig(11 downto 8);
            bl4<=temp_b2;
        end if ;
        anode <= "1110";
        
    end if ;
end process;
end Behavioral;