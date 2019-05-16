library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VendingMachine is
  Port(
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
end VendingMachine;

architecture Behavioral of VendingMachine is

    -- Input Signals
    signal s_clk       : STD_LOGIC;
    signal s_coinID : STD_LOGIC_VECTOR (2 downto 0);
    signal s_sensor    : STD_LOGIC;
    signal s_itemID    : STD_LOGIC_VECTOR (2 downto 0);
    -- Misc Signals
    signal s_power     : STD_LOGIC;
    signal s_reset     : STD_LOGIC;
        
    -- Internal Signals
    signal s_itemValue  : STD_LOGIC_VECTOR(15 downto 0);
    signal s_readSignal : STD_LOGIC;
    signal s_credit     : STD_LOGIC_VECTOR(15 downto 0);
    signal s_subItemVal : STD_LOGIC;
    signal s_valueToSub : STD_LOGIC_VECTOR(15 downto 0);
        
    -- Output Singals
    signal s_giveChange : STD_LOGIC;
    signal s_change     : STD_LOGIC_VECTOR(15 downto 0);
    signal s_changeDone : STD_LOGIC;
    signal s_itemDone   : STD_LOGIC;
        
    
begin
    -- Input port maps
    s_clk <= clk;
    s_coinID <= coinID;
    s_sensor <= sensor;
    s_itemID <= itemID;
    s_reset <= reset;
    s_power <= power;
    
    -- Output port maps
    change <= s_change;
    changeDone <= s_changeDone;
    itemDone <= s_itemDone;
    
    itemDecode: entity work.ItemDecoder port map(
        clk        => s_clk,
        item       => s_itemID,
        value      => s_itemValue,
        read       => s_readSignal
    );
    
    creditControl: entity work.CreditController port map(
        GCLK   => s_clk,
        RST    => s_reset,
        
        coinID => s_coinID,
        sensor => s_sensor,
        
        toSub        => s_valueToSub,
        subItemValue => s_subItemVal,
        giveChange   => s_giveChange,
        
        credit => s_credit,
        change => s_change,
        changeDone => s_changeDone
    );
    
    mainControl : entity work.MainController port map(
        clk        => s_clk,
        readSignal => s_readSignal,
        itemValue  => s_itemValue,
        credit     => s_credit,
        reset      => s_reset,
        power      => s_power,
        
        subItemVal => s_subItemVal,
        valueToSub => s_valueToSub,
        giveChange => s_giveChange,
        itemDone   => s_itemDone
    );
end Behavioral;
