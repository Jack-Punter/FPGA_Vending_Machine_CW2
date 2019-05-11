----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2018 18:14:41
-- Design Name: 
-- Module Name: tb_CreditController - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_CreditController is
--  Port ( );
end tb_CreditController;

architecture Behavioral of tb_creditController is
    component creditController is port(
        GCLK : in STD_LOGIC;
        coinID   : in STD_LOGIC_VECTOR (2 downto 0);
        sensor : in STD_LOGIC;
        toSub  : in STD_LOGIC_VECTOR (15 downto 0);
        sub    : in STD_LOGIC;
        RST : in STD_LOGIC;
        credit : out STD_LOGIC_VECTOR (15 downto 0) 
    );
    end component;
    signal s_GCLK         : STD_LOGIC;
    constant clk_period   : time := 10ns;
    signal s_coin         : STD_LOGIC_VECTOR (2 downto 0);
    signal s_sensor       : STD_LOGIC;
    signal s_toSub        : STD_LOGIC_VECTOR (15 downto 0);
    signal s_sub          : STD_LOGIC;
    signal s_creditStored : STD_LOGIC_VECTOR (15 downto 0);
    signal s_reset        : STD_LOGIC;
begin
    utt: creditController port map(
        GCLK => s_GCLK,
        coinID => s_coin,
        sensor => s_sensor,
        toSub => s_toSub,
        sub => s_sub,
        RST => s_reset,
        credit => s_creditStored
    );
    
    clkProc : process
    begin
        s_GCLK <= '0';
        wait for clk_period/2;
        s_GCLK <= '1';
        wait for clk_period/2;
    end process;
    
    stimProc: process
    begin
        s_reset <= '1';
        s_coin <= "000";
        s_sensor <= '0';
        s_toSub <= x"0000";
        s_sub <= '0';
        wait for 10ns;
        
        s_reset <= '0';
        wait for 5ns;
        
        wait for clk_period*5;
        s_coin <= "010";
        s_sensor <= '1';
        wait for clk_period;
        s_sensor <= '0';
        wait for clk_period;
        s_coin <= "100";
        s_sensor <= '1';
        
        wait;
        s_coin <= "001";
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;
        
        s_coin <= "010";
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;

        s_coin <= "011";
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;

        s_coin <= "100";
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;

        s_coin <= "101";
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;
        s_sensor <= '1';
        wait for 5ns;
        s_sensor <= '0';
        wait for 5ns;
        
        s_toSub <= x"0064";
        s_sub <= '1';
        wait for 5ns;
        s_toSub <= x"0000";
        s_sub <= '0';

        s_reset <= '1';
        wait for 5ns;
        s_reset <= '0';
        wait;
    end process;
end Behavioral;











