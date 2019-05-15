library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity creditController is
    Port (
        GCLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        
        coinID : in STD_LOGIC_VECTOR (2 downto 0);
        sensor : in STD_LOGIC;
        
        toSub        : in STD_LOGIC_VECTOR (15 downto 0);
        subItemValue : in STD_LOGIC;
        giveChange   : in STD_LOGIC;
                
        credit     : out STD_LOGIC_VECTOR (15 downto 0);
        --creditRead : out STD_LOGIC;
        change     : out STD_LOGIC_VECTOR (15 downto 0);
        changeDone : out STD_LOGIC
    );
end creditController;

architecture Behavioral of creditController is
    -- Types used as the memroy for coin storage and value lookup
    type CoinValueLookup_t is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    type CashBox_t is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    
    -- The Coin ID as an unsined int is the index into this array
    -- The value at the index is the value of that coin
    constant CoinValueLookup : CoinValueLookup_t := (
        x"0000", -- £00.00
        x"000A", -- £00.10
        x"0014", -- £00.20
        x"0032", -- £00.50
        x"0064", -- £01.00
        x"00C8", -- £02.00
        x"01F4", -- £05.00
        x"03E8"  -- £10.00
    );

    -- The Coin ID as an unsined int is the index into this array
    -- The value at the index is the number of that coin we have left
    -- It is assumed that we start with 16 of each coin type in the cash box
    signal s_CashBox : CashBox_t := (
        x"0000", -- £00.00
        x"0050", -- £00.10
        x"0050", -- £00.20
        x"0050", -- £00.50
        x"0050", -- £01.00
        x"0050", -- £02.00
        x"0050", -- £05.00
        x"0050"  -- £10.00
    );
    
    -- Port signals
    signal s_coinId    : STD_LOGIC_VECTOR(2 downto 0);
    signal s_creditStore : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    --signal s_creditRead : STD_LOGIC := '0';
    signal s_change : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_changeDone : STD_LOGIC := '0';
    -- Signals to hold the values from the lookup arrays
    -- The Value of the coin ID 
    signal s_coinValue : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    -- The ammount of that coin remianing
    signal s_coinAmount : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    signal s_adderInput : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_adderOutput : STD_LOGIC_VECTOR(15 downto 0);
    signal s_adderCarryOut : STD_LOGIC;
    
    signal s_subtractorInput : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_subtractorOutput : STD_LOGIC_VECTOR(15 downto 0);
    signal s_subtractorCarryOut : STD_LOGIC;
    --adder control singnals
    signal s_adderRead : STD_LOGIC := '0';
    signal s_subtractorRead : STD_LOGIC := '0';
    
    -- Signal to store credit remianing to give as change
    signal s_changeAmount : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_changeCoinID  : integer := 7;
    signal s_changeCoinVal : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_givingChange : STD_LOGIC := '0';
    
    signal s_subCashBox : STD_LOGIC := '0';
    signal s_subChange : STD_LOGIC := '0';
    
    signal s_coinDispenced : STD_LOGIC := '0';
    
begin
    s_coinID <= coinID;
    credit <= s_creditStore;
    --creditRead <= s_creditRead;
    change <= s_change;
    changeDone <= s_changeDone;
    
    
    --s_adderInput <= s_coinValue;
    adder: entity work.multiBitAdder port map(
        input1pin => s_creditStore,
        --input2pin => s_adderInput,
        input2pin => s_coinValue,
        output => s_adderOutput,
        carryIn => '0',
        carryOut => s_adderCarryOut
    );

    subtractor: entity work.multiBitSubtractor port map(
        input1 => s_creditStore,
        input2 => s_subtractorInput,
        output => s_subtractorOutput,
        carryOut => s_subtractorCarryOut
    );

    addCredit: process(GCLK, sensor, subItemValue, giveChange, coinID)
    begin
        if rising_edge(GCLK) then
            -- If high creditRead was high last cycle, set low
--            if s_creditRead = '1' then
--                s_creditRead <= '0';
--            end if;
            
            -- Coin inserted
            if sensor = '1' then
                -- Decode coin and increment CashBox values
                s_coinValue <= CoinValueLookup(to_integer(unsigned('0' & coinID)));
                s_CashBox(to_integer(unsigned('0' & coinID))) <= s_CashBox(to_integer(unsigned('0' & coinID))) + 1;
                s_adderRead <= '1';
            -- Item Selected, remove price from credit 
            elsif subItemValue = '1' then
                s_subtractorInput <= toSub;
                s_subtractorRead <= '1';
            -- Return change to user 
            elsif giveChange = '1' then
                s_givingChange <= '1';
                s_changeAmount <= s_creditStore;
                s_creditStore <= (others => '0');
            end if;
            
            -- Last Cycle value was added to adder input
            -- Value ready to read
            if s_adderRead = '1' then
                s_adderRead <= '0';
                if s_adderCarryOut = '1' then
                    s_givingChange <= '1';
                    s_changeAmount <= s_coinValue;
                else
                    s_creditStore <= s_adderOutput;
                end if;
                --s_creditRead <= '1';
            end if;
            -- Last Cycle value was added to subtractor input
            -- Output ready to read
            if s_subtractorRead = '1' then
                s_subtractorRead <= '0';
                s_creditStore <= s_subtractorOutput;
            end if;
                
            if s_coinDispenced = '1' then
                s_coinDispenced <= '0';
            end if;
            
            if s_change /= x"0000" then
                s_change <= x"0000";
            end if;
            -- Change Giving
            if s_givingChange = '1' and s_subCashBox = '0' and s_subChange = '0' then
                if s_changeCoinVal /= CoinValueLookup(s_changeCoinID) then
                    s_changeCoinVal <= CoinValueLookup(s_changeCoinID);
                 else
                    if s_changeCoinVal <= s_changeAmount and s_CashBox(s_changeCoinID) /= x"0000" then
                    --if s_changeCoinVal <= s_changeAmount then
                        s_change <= s_changeCoinVal;
                        --s_changeAmount <= s_changeAmount - s_changeCoinVal;
                        --s_CashBox(s_changeCoinID) <=  s_CashBox(s_changeCoinID) - 1;
                        s_subChange <= '1';
                        s_subCashBox <= '1';                    
                        s_coinDispenced <= '1';
                    else
                        s_changeCoinID <= s_changeCoinID - 1; 
                    end if;
                end if;

                if s_changeAmount = x"0000" then
                    s_changeDone <= '1';
                    s_change <= (others => '0');
                end if;
                if s_changeDone = '1' then
                    s_changeCoinID <= 7;
                    s_changeDone <= '0';
                    s_givingChange <= '0';
                end if;
            end if;
            
            if s_subCashBox = '1' then
                s_CashBox(s_changeCoinID) <=  s_CashBox(s_changeCoinID) - 1;
                s_subCashBox <= '0';  
            end if;
            
            if s_subChange = '1' then
                s_changeAmount <= s_changeAmount - s_changeCoinVal;
                s_subChange <= '0';
            end if;
            --signal s_subCashBox : STD_LOGIC := '0';
            --signal s_subChange : STD_LOGIC := '0';
            
            -- Reset procedure 
            if RST = '1' then
                s_creditStore <= (others => '0');
                s_coinValue <= (others => '0');
            end if;
            
        end if;
    end process;

end Behavioral;
