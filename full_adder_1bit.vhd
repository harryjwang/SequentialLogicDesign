-- Author: Group 10, Albert Zhou, Harry Wang 
library ieee;
use ieee.std_logic_1164.all;

entity one_bit_full_adder is
	
	port (
		input_a, input_b, carry_bit_in : in std_logic; -- input single digit inputs a and b as well as a carry bit
		sum_output, carry_output : out std_logic		  -- outputs a sum value as well as takes the carry if the two values are the both 1's
		);
		
end one_bit_full_adder;

architecture adder_logic_one_bit of one_bit_full_adder is
	signal half_adder_sum_output : std_logic;				-- intialize the signal that is the half adder sum output
	signal half_adder_carry_output: std_logic;			-- initalize signal that represents the carry output (ie. if the two bits both 1)
begin
	half_adder_sum_output <= input_b XOR input_a; 		-- half adder sum is created by comparing inputs b and a with XOR
	half_adder_carry_output <= input_b AND input_a;		-- half adder carry output is created by comparing inputs b and a with AND
	
	sum_output <= half_adder_sum_output XOR carry_bit_in; -- sum output of the full adder for one bit input is created by
																			-- comparing half adder sum output with carry bit with XOR to check that
																			-- if both of the inputs (half adder sum output and carry bit) are the same 
																			-- (ie. 0 and 0, or 1 and 1, the output is 0 - meaning the sum is 0)
	
	carry_output <= half_adder_carry_output OR (carry_bit_in AND half_adder_sum_output);
																			-- carry output is created by comparing the carry output from the half adder with 
																			-- the carry bit AND the half adder sum output. This shows that if the two numbers are 
																			-- both 1's then the output is 1. This makes sense because if you at binary 1+1 it gives
																			-- 0 with the carry bit to be 1 which in this case is true.
																			-- Then, the comparison of the carry bit AND half adder sum output OR with the half adder 
																			-- carry output gives us the comparison to see if either one of the two carry outputs are 
																			-- equal to 1, then the carry output of the full adder will equal to 1
	
	
	
end adder_logic_one_bit;