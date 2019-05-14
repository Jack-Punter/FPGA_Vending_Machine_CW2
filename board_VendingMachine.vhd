----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2019 18:30:17
-- Design Name: 
-- Module Name: board_VendingMachine - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity board_VendingMachine is
    Port (
        GCLK, BTNC, BTNU, BTND, BTNL, BTNR : in STD_LOGIC;
        SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7 : in STD_LOGIC;
        LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7 : out STD_LOGIC
    );
end board_VendingMachine;

architecture Behavioral of board_VendingMachine is
    --Vending machine Singals
    -- -> Input Signals
        signal s_reset, s_power, s_vmClk, s_sensor : STD_LOGIC;
        signal s_coinID, s_itemID : STD_LOGIC_VECTOR(2 downto 0);
    -- -> Internal Singals
        signal s_itemRead, s_subItemVal, s_giveChange : STD_LOGIC;
        signal s_itemVal, s_credit, s_toSub : STD_LOGIC_VECTOR(15 downto 0);
    -- -> Output Singals
        signal s_changeDone, s_itemDone : STD_LOGIC;
        signal s_change : STD_LOGIC_VECTOR(15 downto 0);
    -- Misc Signals
    signal s_GCLK : STD_LOGIC := '0';
    signal s_tmpItemID : STD_LOGIC_VECTOR(2 downto 0);
    signal s_btnlLatch, s_btnrLatch : STD_LOGIC := '0';
    signal s_changeOut : STD_LOGIC_VECTOR(3 downto 0);
begin
    -- Port Maps
    -- Ouptut
    LD6 <= s_vmClk;
    LD7 <= s_itemDone;
    LD5 <= s_changeDone;
    (LD4, LD3, LD2, LD1, LD0) <= s_changeOut;
--    LD4 <= s_change(4);
--    LD3 <= s_change(3);
--    LD2 <= s_change(2);
--    LD1 <= s_change(1);
--    LD0 <= s_change(0);
    -- Input
    s_GCLK <= GCLK;
    s_tmpItemID <= (SW7, SW6, SW5);
    s_power <= SW4;
    s_reset <= SW3;
    s_coinID <= (SW2, SW1, SW0);
    
    changeProc: process(s_change)
    begin
    case s_change is
        when x"0000" =>
            s_changeOut <= x"0";
        when x"000A" =>
            s_changeOut <= x"1";
        when x"0014" =>
            s_changeOut <= x"2";
        when x"0032" =>
            s_changeOut <= x"3";
        when x"0064" =>
            s_changeOut <= x"4";
        when x"00C8" =>
            s_changeOut <= x"5";
        when x"01F4" =>
            s_changeOut <= x"6";
        when x"03E8" =>
            s_changeOut <= x"7";
        when others =>
            s_changeOut <= x"0";
    end case;
    end process; 
       
    inputProc: process(s_vmClk, BTNL, BTNR)
    begin
    
    if BTNL = '1' and BTNL /= s_btnlLatch then
        s_btnlLatch <= '1';
    end if;
    if BTNR = '1' and BTNR /= s_btnrLatch then
        s_btnrLatch <= '1';
    end if;
    
    if rising_edge(s_vmClk) then
        if s_btnlLatch = '1' then
            s_sensor <= '1';
            s_btnlLatch <= '0';
        end if;
        
        if s_btnrLatch = '1' then
            s_itemID <= s_tmpItemID;
            s_btnrLatch <= '0';
        end if;
        
        if s_sensor = '1' then
            s_sensor <= '0';
        end if;
        
        if s_itemID /= "000" then
            s_itemID <= "000";
        end if;
    end if;
    end process;
    
    -- Component Port maps
    ClockDivide: entity work.ClockDivider port map(
        GCLK => S_GCLK,
        vmClk => s_vmClk        
    );
    
    itemDecode: entity work.ItemDecoder port map(
            clk        => s_vmClk,
            item       => s_itemID,
            value      => s_itemVal,
            read       => s_itemRead
        );
        
        creditControl: entity work.CreditController port map(
            GCLK   => s_vmClk,
            RST    => s_reset,
            
            coinID => s_coinID,
            sensor => s_sensor,
            
            toSub        => s_toSub,
            subItemValue => s_subItemVal,
            giveChange   => s_giveChange,
            
            credit => s_credit,
            change => s_change,
            changeDone => s_changeDone
        );
        
        mainControl : entity work.MainController port map(
            clk        => s_vmClk,
            readSignal => s_itemRead,
            itemValue  => s_itemVal,
            credit     => s_credit,
            reset      => s_reset,
            power      => s_power,
            
            subItemVal => s_subItemVal,
            valueToSub => s_toSub,
            giveChange => s_giveChange,
            itemDone   => s_itemDone
        );

end Behavioral;
