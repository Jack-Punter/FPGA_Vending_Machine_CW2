library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity creditController is
    Port (
        GCLK : in STD_LOGIC;
        coinID : in STD_LOGIC_VECTOR (2 downto 0);
        sensor : in STD_LOGIC;
        toSub : in STD_LOGIC_VECTOR (15 downto 0);
        sub : in STD_LOGIC;
        RST : in STD_LOGIC;
        credit : out STD_LOGIC_VECTOR (15 downto 0)
    );
end creditController;

architecture Behavioral of creditController is

    type CoinValueLookup_t is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    type CashBox_t is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    
    
    -- The Coin ID as an unsined int is the index into this array
    -- The value at the index is the value of that coin
    constant CoinValueLookup : CoinValueLookup_t := (
        x"0000", -- �00.00
        x"000A", -- �00.10
        x"0014", -- �00.20
        x"0032", -- �00.50
        x"0064", -- �01.00
        x"00C8", -- �02.00
        x"01F4", -- �05.00
        x"03E8"  -- �10.00
    );

    -- The Coin ID as an unsined int is the index into this array
    -- The value at the index is the number of that coin we have left
    -- It is assumed that we start with 16 of each coin type in the cash box
    signal s_CashBox : CashBox_t := (
        x"0000", -- �00.00
        x"0010", -- �00.10
        x"0010", -- �00.20
        x"0010", -- �00.50
        x"0010", -- �01.00
        x"0010", -- �02.00
        x"0010", -- �05.00
        x"0010"  -- �10.00
    );
    
    signal s_coinId    : STD_LOGIC_VECTOR(2 downto 0);
    signal s_creditStore : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    
    -- Signals to hold the values from the lookup arrays
    -- The Value of the coin ID 
    signal s_coinValue : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    -- The ammount of that coin remianing
    signal s_coinAmount : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    
    signal s_adderInput : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_adderOutput : STD_LOGIC_VECTOR(15 downto 0);
    signal s_adderCarryOut : STD_LOGIC;
    
    signal s_subtractorInput : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal s_subtractorOutput : STD_LOGIC_VECTOR(15 downto 0);
    signal s_subtractorCarryOut : STD_LOGIC;
    --adder control singnals
    signal s_adderRead : STD_LOGIC := '0';
    signal s_subtractorRead : STD_LOGIC := '0';
    
begin
    s_coinID <= coinID;
    credit <= s_creditStore;
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

    addCredit: process(GCLK, sensor, coinID)
    begin
        if rising_edge(GCLK) then
            -- Coin inserted
            if sensor = '1' then
                -- Decode coin and increment CashBox values
                s_coinValue <= CoinValueLookup(to_integer(unsigned('0' & coinID)));
                s_CashBox(to_integer(unsigned('0' & coinID))) <= s_CashBox(to_integer(unsigned('0' & coinID))) + 1;
                s_adderRead <= '1';
            -- Value to be subtracted
            elsif sub = '1' then
                s_subtractorInput <= toSub;
                s_subtractorRead <= '1';
            end if;
            
            -- Last Cycle value was added to adder input
            -- Value ready to read
            if s_adderRead = '1' then
                s_adderRead <= '0';
                s_creditStore <= s_adderOutput;
            end if;
            -- Last Cycle value was added to subtractor input
            -- Output ready to read
            if s_subtractorRead = '1' then
                s_subtractorRead <= '0';
                s_creditStore <= s_subtractorOutput;
            end if;
            
            -- Reset procedure 
            if RST = '1' then
                s_creditStore <= (others => '0');
                s_coinValue <= (others => '0');
            end if;
        end if;
    end process;

end Behavioral;
