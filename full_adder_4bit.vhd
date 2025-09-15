-- Author: Group 10, Albert Zhou, Harry Wang 
library ieee;
use ieee.std_logic_1164.all;

entity full_adder_4bit is
	port
	(
		BUS0, BUS1 : in std_logic_vector(3 downto 0); -- two hexadecimal values that will be added together
		carry_in : in std_logic;							 -- carry in bit that tells the program what the carry in value is
		SUM : out std_logic_vector(3 downto 0);		 -- gives the sum of the hexadecimal values
		carry_out : out std_logic							 -- carry bit output meaning, the carry bit that gets output when the hex values are added
	);
end full_adder_4bit;

architecture logic_four_bit_full_adder of full_adder_4bit is
component one_bit_full_adder
	-- exact same inputs that are pulled from the one bit full adder file we made right before this --
	port (
		input_a, input_b, carry_bit_in : in std_logic; -- input single digit inputs a and b as well as a carry bit
		sum_output, carry_output : out std_logic		  -- outputs a sum value as well as takes the carry if the two values are the both 1's
		);
	end component;
	
	signal carry0 : std_logic;		-- creates a first carry bit to store for first addition step
	signal carry1 : std_logic;		-- creates a second carry bit to store for the second addition step
	signal carry2 : std_logic;		-- creates a thrid carry bit to store for the second addition step
	
begin

	INST1 : one_bit_full_adder port map(BUS0(0), BUS1(0), carry_in, SUM(0), carry0);   -- addition of the least significant of both inputs
																												  -- and carry_in bit and gives the sum of the bits store in SUM(_), 
																												  -- and the carry0 is set to equal the carry bit used in the next
																												  -- summation
	
	INST2 : one_bit_full_adder port map(BUS0(1), BUS1(1), carry0, SUM(1), carry1);	  -- addition of the second least significant of both inputs
																												  -- and carry0 bit from the previous calculation and gives the sum of the bits store in SUM(_), 
																												  -- and the carry1 is set to equal the carry bit used in the next
																												  -- summation
	
	INST3 : one_bit_full_adder port map(BUS0(2), BUS1(2), carry1, SUM(2), carry2);	  -- addition of the second most significant of both inputs
																												  -- and carry1 bit from the previous calculation and gives the sum of the bits store in SUM(_), 
																												  -- and the carry1 is set to equal the carry bit used in the next
																												  -- summation
	
	INST4 : one_bit_full_adder port map(BUS0(3), BUS1(3), carry2, SUM(3), carry_out); -- addition of the most significant of both inputs
																												  -- and carry2 bit from the previous calculation and gives the sum of the bits store in SUM(_), 
																												  -- and the carry_out is set to equal the final carry bit.  This basically shows that if the 
																												  -- summation of the two hexadecimal values are greater than F (15), then the carry bit of the
																												  -- entire summation if 1 which would then represent 16.
	
end logic_four_bit_full_adder;