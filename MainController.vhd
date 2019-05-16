library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MainController is Port(
    clk        : in STD_LOGIC;
    readSignal : in STD_LOGIC;
    itemValue  : in STD_LOGIC_VECTOR (15 downto 0);
    credit     : in STD_LOGIC_VECTOR (15 downto 0);
    reset      : in STD_LOGIC;
    power      : in STD_LOGIC; 
    
    subItemVal : out STD_LOGIC;
    valueToSub : out STD_LOGIC_VECTOR (15 downto 0);
    giveChange : out STD_LOGIC;
    itemDone   : out STD_LOGIC
);
end MainController;

architecture Behavioral of MainController is
    type t_state is (Waiting, CreditCheck, ComputeChange, ChangeCheck, OutputChangeDelay, OutputChange, ResetState);
    signal state : t_state := ResetState;

    --Input Signals    
    signal s_credit : STD_LOGIC_VECTOR (15 downto 0);
    signal s_itemValue  : STD_LOGIC_VECTOR (15 downto 0);
    --signal s_reset : STD_LOGIC;
    --signal s_power : STD_LOGIC;
    
    --Output Signals
    signal s_subItemVal : STD_LOGIC := '0';
    signal s_valueToSub : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
    signal s_giveChange : STD_LOGIC := '0';
    signal s_itemDone   : STD_LOGIC := '0';
    
begin
    -- Input Signal Maps
    s_credit <= credit;

    -- Output Signal maps
    subItemVal <= s_subItemVal;
    giveChange <= s_giveChange;
    valueToSub <= s_valueToSub;
    itemDone <= s_itemDone;
        
    process(clk, readSignal, reset, power)
    begin
    if rising_edge(clk) then
        case state is
            when ResetState =>
                s_subItemVal <= '0';
                s_valueToSub <= x"0000";
                s_giveChange <= '1';
                s_itemDone <= '0';
                state <= Waiting;
            
            when Waiting =>
                s_giveChange <= '0';
                state <= Waiting;
            
            when CreditCheck =>
                if (unsigned(s_credit) < unsigned(s_itemValue)) then
                    state <= Waiting;
                else 
                    state <= ComputeChange;
                end if;
            
            when ComputeChange =>
                s_valueToSub <= s_itemValue;
                s_subItemVal <= '1';
                s_itemDone <= '1';
                state <= ChangeCheck;
            
            when ChangeCheck =>
                s_subItemVal <= '0';
                s_itemDone <= '0';
                if (s_credit = x"0000") then
                    state <= ResetState;
                else
                    state <= OutputChange;
                end if;
            
            when OutputChangeDelay =>
                state <= OutputChange;
            
            when OutputChange =>
                --s_giveChange <= '1';
                state <= ResetState;
        end case;
        if reset = '1' or power = '0' then
            state <= ResetState;
        elsif readSignal = '1' and state = Waiting then
            s_itemValue <= itemValue;
            state <= CreditCheck;
        end if;
    end if;
    end process;
end Behavioral;