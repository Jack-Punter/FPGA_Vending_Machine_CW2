----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 31.12.2018 17:01:59
-- Design Name:
-- Module Name: tb_VendingMachine - Behavioral
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

entity tb_VendingMachine is
--  Port ( );
end tb_VendingMachine;

architecture Behavioral of tb_VendingMachine is
    component VendingMachine is Port(
        -- Input Ports
        clk       : in STD_LOGIC;
        coinID : in STD_LOGIC_VECTOR (2 downto 0);
        sensor    : in STD_LOGIC;
        itemID    : in STD_LOGIC_VECTOR (2 downto 0);
        reset     : in STD_LOGIC;
        power     : in STD_LOGIC;
        
        -- Output Ports
        change     : out STD_LOGIC_VECTOR (15 downto 0);
        changeDone : out STD_LOGIC;
        itemDone   : out STD_LOGIC
    );
    end component;

    constant clk_period : TIME := 10ns;
    -- Input Signals
    signal s_clk       : STD_LOGIC;
    signal s_coinID    : STD_LOGIC_VECTOR (2 downto 0);
    signal s_sensor    : STD_LOGIC;
    signal s_itemID    : STD_LOGIC_VECTOR (2 downto 0);
    signal s_reset     : STD_LOGIC;
    signal s_power     : STD_LOGIC;

    -- Output Singals
    signal s_change     : STD_LOGIC_VECTOR(15 downto 0);
    signal s_changeDone : STD_LOGIC;
    signal s_itemDone   : STD_LOGIC;
begin
    s_power <= '1';
    utt: VendingMachine port map(
        -- Input Ports
        clk       => s_clk,
        coinID => s_coinID,
        sensor    => s_sensor,
        itemID    => s_itemID,
        reset     => s_reset,
        power     => s_power,

        -- Output Ports
        change     => s_change,
        changeDone => s_changeDone,
        itemDone   => s_itemDone
    );


    clk_proc : process
    begin
        s_clk <= '1';
        wait for clk_period/2;
        s_clk <= '0';
        wait for clk_period/2;
    end process;

    stim_proc : process
    begin
        s_reset <= '0';
        s_coinID <= "000";
        s_sensor    <= '0';
        s_itemID    <= "000";

        wait for clk_period*5;
        s_coinID <= "010";
        s_sensor <= '1';
        wait for clk_period;
        s_sensor <= '0';
        s_coinID <= "000";
        wait for clk_period;
        s_coinID <= "100";
        s_sensor <= '1';
        wait for clk_period;
        s_sensor <= '0';
        s_coinID <= "000";
        s_itemID <= "111";
        wait for clk_period;
        s_itemID <= "000";
        wait for clk_period*10;
        
--        s_coinValue <= x"0078";
--        s_sensor <= '1';
--        wait for clk_period;
--        s_coinValue <= x"0000";
--        s_sensor <= '0';
--        s_itemID <= "001";
--        wait for clk_period;
--        s_itemID <= "000";
--        wait for clk_period*10;

--        s_coinValue <= x"003C";
--        s_sensor <= '1';
--        wait for clk_period;
--        s_coinValue <= x"0000";
--        s_sensor <= '0';
--        s_itemID <= "011";
--        wait for clk_period;
--        s_itemID <= "000";
--        wait for clk_period*10;
        
--        s_itemID <= "100";
--        wait for clk_period;
--        s_itemID <= "000";
        wait;
    end process;

end Behavioral;
