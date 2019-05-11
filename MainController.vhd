----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2018 19:39:45
-- Design Name: 
-- Module Name: MainController - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainController is Port(
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
end MainController;

architecture Behavioral of MainController is
    type t_state is (Waiting, CreditCheck, ComputeChange, ChangeCheck, OutputChangeDelay, OutputChange, ResetState);
    signal state : t_state := ResetState;

    --Input Signals    
    signal s_credit : STD_LOGIC_VECTOR (15 downto 0);
    signal s_itemValue  : STD_LOGIC_VECTOR (15 downto 0);
    signal s_reset : STD_LOGIC;
    signal s_power : STD_LOGIC;
    
    --Output Signals
    signal s_sub : STD_LOGIC := '0';
    signal s_valueToSub : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
    signal s_change : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal s_changeDone : STD_LOGIC := '0';
    signal s_itemDone : STD_LOGIC := '0';
    
begin
    -- Input Signal Maps
    s_credit <= credit;
    s_reset <= reset;
    s_power <= power;
    -- Output Signal maps
    sub <= s_sub;
    valueToSub <= s_valueToSub;
    change <= s_change;
    changeDone <= s_changeDone;
    itemDone <= s_itemDone;
        
    process(clk, readSignal, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= ResetState;
            elsif readSignal = '1' and state = Waiting then
                s_itemValue <= itemValue;
                state <= CreditCheck;
            elsif power = '0' then
                state <= ResetState;
            else
                case state is
                    when ResetState =>
                        s_sub <= '0';
                        s_valueToSub <= x"0000";
                        s_change <= x"0000";
                        s_changeDone <= '0';
                        s_itemDone <= '0';
                        state <= Waiting;
                        
                    when Waiting =>
                        state <= Waiting;
                        
                    when CreditCheck =>
                        if (unsigned(s_credit) < unsigned(s_itemValue)) then
                            state <= Waiting;
                        else 
                            state <= ComputeChange;
                        end if;
                        
                    when ComputeChange =>
                        s_valueToSub <= s_itemValue;
                        s_sub <= '1';
                        s_itemDone <= '1';
                        state <= ChangeCheck;
                        
                    when ChangeCheck =>
                        s_sub <= '0';
                        s_itemDone <= '0';
                        if (s_credit = x"0000") then
                            state <= ResetState;
                        else
                            state <= OutputChangeDelay;
                        end if;
                        
                    when OutputChangeDelay =>
                        state <= OutputChange;
                        
                    when OutputChange =>
                        s_change <= credit;
                        s_valueToSub <= credit;
                        s_sub <= '1';
                        s_changeDone <= '1';
                        state <= ResetState;
                end case;
            end if;
        end if;
    end process;
end Behavioral;