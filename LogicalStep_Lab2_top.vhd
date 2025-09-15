-- Author: Group 10, Albert Zhou, Harry Wang 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
	
	component segment7_mux port(								
		clk			: in std_logic := '0';					-- clock set to 0
		DIN2			: in std_logic_vector(6 downto 0);  -- input 2 for segment 7 mutiplixer
		DIN1			: in std_logic_vector(6 downto 0);	-- input 1 for segment 7 multiplixer
		DOUT			: out std_logic_vector(6 downto 0); -- output for segment 7 multiplixer
		DIG2			: out std_logic;							-- toggles the 
		DIG1			: out std_logic							-- 
	);
	end component;

	component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component PB_Inverters port (
		pb_n : IN std_logic_vector(3 downto 0);			-- input for the push buttons
		pb : OUT std_logic_vector(3 downto 0)				-- result of inverting the state of the push buttons
	);
	end component;
	
	component logic_processor port (
		logic_in0, logic_in1 : in std_logic_vector(3 downto 0); 	-- 4 hex inputs that go into the logic processor
		processor_select		: in std_logic_vector( 1 downto 0);	-- selects based on the state of push buttons 0 and 1
		logic_out				: out std_logic_vector(3 downto 0)  -- result of the select and different states of the push buttons 
																					-- due to comparison of switches (on or off) -- Leds light up in different situations
	);
	end component;
	
	component full_adder_4bit port (
		BUS0, BUS1 : in std_logic_vector(3 downto 0); -- two hexadecimal values that will be added together
		carry_in : in std_logic;							 -- carry in bit that tells the program what the carry in value is
		SUM : out std_logic_vector(3 downto 0);		 -- gives the sum of the hexadecimal values
		carry_out : out std_logic							 -- carry bit output meaning, the carry bit that gets output when the hex values are added
	);
	end component;
	
	component two_to_one_multiplixer port(
		multiplixer_input_a, multiplixer_input_b : in std_logic_vector(3 downto 0); -- two hexadecimal inputs, represented by vectors
		multiplixer_select : in std_logic;														 -- multipliexer select input (1 or 0 which indicates on or off)
		multiplixer_output : out std_logic_vector(3 downto 0)								 -- output result from the multiplixer
	);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0);		-- initializes signal that represents the values that get displayed on the board
	signal seg7_B		: std_logic_vector(6 downto 0);		
	
	signal hex_A		: std_logic_vector(3 downto 0);		
	signal hex_B		: std_logic_vector(3 downto 0);		-- initializes the hexadecimal values that are used for calculations

	signal pb 			: std_logic_vector(3 downto 0);		-- initializes the push button signal that is a hex value
	
	signal single_carry_bit: std_logic;  -- initializes the signal that represents the single carry bit that results from the summation of the hexA and hexB
	signal carry_on		: std_logic_vector(3 downto 0);  -- created hexadecimal value that is the single bit carry written in the form of hexadecimal
	signal summation : std_logic_vector(3 downto 0);		-- summation of the two hexadecimal values (hexA and hexB)
	signal multiplixer_output_a: std_logic_vector(3 downto 0);		-- initializes the hexadecimal value that is outputed depending on the pb(2) is on (1) -> carry or off (0) -> hex_B
	signal multiplixer_output_b: std_logic_vector(3 downto 0);		-- initializes the hexadecimal value that is outputed depending on the pb(2) is on (1) -> summation or off (0) -> hex_A
	
	
-- Here the circuit begins

begin

	hex_A <= sw(3 downto 0);  -- sets hex_A to be equal to the dexidecimal value that is represented from switches 0 to 3
	hex_B <= sw (7 downto 4); -- sets hex_B to be equal to the dexidecimal value that is represented from switches 4 to 7
	
-- COMPONENT HOOKUP
--
-- generate the seven segment coding
	


	INST1: pb_inverters port map(pb_n, pb); -- input the normal push button setting/state and output the push button state (pb) after the buttons have been switched
														 -- from active low to active high
														 
	INST2: logic_processor port map(hex_A, hex_B, pb(1 downto 0), leds(3 downto 0)); -- inputs the two hex values A and B and the push buttons (00, 01, 10, 11) and runs the 
																												-- logic processor that compares the values of the hex A and B (switches 0 to 3 and seithces 4 to 7 respectively)
																												-- and based on the push button combination, runs the comparisons (AND, OR, XOR, or XNOR) respectively and if the 
																												-- output of the comparison is 1, then the led at the corresponding switch (switch 0 to 3) will light up
	
	INST3: full_adder_4bit port map(hex_A, hex_B,'0', summation, single_carry_bit);	-- inputs into the adder function hex_A and hex_B as well as the initalized carry bit to be 0 because at the beginning
																												-- there's no carry bit when you add. Then, you run through the adder process and get two outputs which are the summation
																												-- of the two hex values and if the addition of the hexes are greater than F(15), then the single carry bit is 1 (represents F)
	
	carry_on <= "000" & single_carry_bit; -- adding the single carry bit (0 or 1) to 000 in order to create a hex value to turn the single carry bit to a hex carry value
	
	INST4: two_to_one_multiplixer port map( hex_B, carry_on, pb(2), multiplixer_output_a);	-- put the value of hex_b and the carry_on value into the 2-1 multiplixer. depending on the state of push button 2,
																														-- if the push button is set to 1, then the value that is outputed (first of the two values on the display) is the carry
																														-- bit that we got. (Basically if the addition of the two hex values are > 15 (F), the the first digit will be one (represents 16) if the pb(2)
																														-- is set to 1. On the other hand, if the pb(2) is set to be 0 (button not pressed), then the hex value (converted to decimal)
																														-- will be outputed as the first digit on the display.
																														
	INST5: two_to_one_multiplixer port map(hex_A, summation, pb(2), multiplixer_output_b); -- input values of the hex_A and the summation of the hex values go into the multliplixer. Depending on the pb(2) if it is on the 
																														-- 0 state (button not pressed), then the display will show the decimal version of hex_A as the second digit.
																														-- However, if the pb(2) is set to 1 (button pressed) then the sum value that we got will display as the equivalent decimal value as
																														-- the second digit of the display
	
	
	INST6: SevenSegment port map(multiplixer_output_a, seg7_A); 		
	INST7: SevenSegment port map(multiplixer_output_b, seg7_B);		-- This explanation was mentioned in the two to one mutliplixer code but this portion of the code
																						-- converts the two segments of hexademical (switches 0 to 3 and switches 4 to 7) and converts the hexadecimal
																						-- to the corresponding values (0-F) according to the table in "SevenSegment.vhd"
	
	
	INST8: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data, seg7_char1, seg7_char2); -- 
	
end SimpleCircuit;

