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
    signal s_btnlLatch, s_btnrLatch, s_btncLatch : STD_LOGIC := '0';
    signal s_changeOut : STD_LOGIC_VECTOR(3 downto 0);
    
    signal s_coinInBuffer, s_itemInBuffer, s_resetBuffer : std_LOGIC := '0';
begin
    -- Port Maps
    -- Ouptut
    LD7 <= s_vmClk;
    LD6 <= s_itemDone;
    LD5 <= s_changeDone;
    
    (LD3, LD2, LD1, LD0) <= s_changeOut;
    -- Input
    s_GCLK <= GCLK;
    s_tmpItemID <= (SW7, SW6, SW5);
    s_power <= SW4;
    s_coinID <= (SW2, SW1, SW0);
    s_reset <= s_btncLatch;
    
    
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
       
       
    process
    begin
    if rising_edge(s_vmClk) then
        s_coinInBuffer <= BTNL;
        s_itemInBuffer <= BTNR;
        s_resetBuffer <= BTNC; 
    end if; 
    end process;
    
    process
    begin
    if rising_edge(s_vmClk) then
        if s_coinInBuffer = '0' and BTNL = '1' then
            s_btnlLatch <= '1';
        else
            s_btnlLatch <= '0';
        end if;
        
        if s_itemInBuffer = '0' and BTNR = '1' then
            s_btnrLatch <= '1';
        else
            s_btnrLatch <= '0';
        end if;
        
        if s_resetBuffer = '0' and BTNC = '1' then
            s_btncLatch <= '1';
        else
            s_btncLatch <= '0';
        end if;  
    end if; 
    end process;
        
    inputProc: process(s_vmClk, BTNL, BTNR)
    begin
    if rising_edge(s_vmClk) then
        if s_btnlLatch = '1' then
            s_sensor <= '1';
        end if;
        
        if s_btnrLatch = '1' then
            s_itemID <= s_tmpItemID;
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
