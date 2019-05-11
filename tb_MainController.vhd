----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 30.12.2018 13:12:37
-- Design Name:
-- Module Name: tb_MainController - Behavioral
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

entity tb_MainController is
--  Port ( );
end tb_MainController;

architecture Behavioral of tb_MainController is
    component MainController is port(
        clk        : in STD_LOGIC;
        readSignal : in STD_LOGIC;
        itemValue  : in STD_LOGIC_VECTOR (15 downto 0);
        credit     : in STD_LOGIC_VECTOR (15 downto 0);
        reset      : in STD_LOGIC;
        power      : in STD_LOGIC;

        sub        : out STD_LOGIC;
        valueToSub : out STD_LOGIC_VECTOR (15 downto 0);
        change     : out STD_LOGIC_VECTOR (15 downto 0);
        changeDone : out STD_LOGIC;
        itemDone   : out STD_LOGIC
    );
    end component;

    constant clk_period : TIME := 10ns;
    -- Input Signals
    signal s_clk : STD_LOGIC;
    signal s_readSignal : STD_LOGIC;
    signal s_itemValue : STD_LOGIC_VECTOR (15 downto 0);
    signal s_credit : STD_LOGIC_VECTOR (15 downto 0);
    signal s_reset : STD_LOGIC;
    signal s_power : STD_LOGIC;


    -- Output signals
    signal s_sub        : STD_LOGIC;
    signal s_valueToSub : STD_LOGIC_VECTOR (15 downto 0);
    signal s_change     : STD_LOGIC_VECTOR (15 downto 0);
    signal s_changeDone : STD_LOGIC;
    signal s_itemDone   : STD_LOGIC;

begin
    utt : MainController port map(
        -- Inputs
        clk        => s_clk,
        readSignal => s_readSignal,
        itemValue  => s_itemValue,
        credit     => s_credit,
        reset      => s_reset,
        power      => s_power,
        -- Outputs
        sub        => s_sub,
        valueToSub => s_valueToSub,
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
        s_readSignal <= '0';
        s_itemValue <= x"0000";
        s_credit <= x"0000";

        wait for clk_period*5;
        s_itemValue <= x"0078";
        s_readSignal <= '1';
        s_credit <= x"0088";
        wait for clk_period;
        s_readSignal <= '0';
        s_itemValue <= x"0000";
        wait;-- for clk_period*10
    end process;

end Behavioral;
