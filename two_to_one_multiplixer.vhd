library ieee;
use ieee.std_logic_1164.all;

entity two_to_one_multiplixer is
	port
	(
		multiplixer_input_a, multiplixer_input_b : in std_logic_vector(3 downto 0); -- two hexadecimal inputs, represented by vectors
		multiplixer_select : in std_logic;														 -- multipliexer select input (1 or 0 which indicates on or off)
		multiplixer_output : out std_logic_vector(3 downto 0)								 -- output result from the multiplixer
	);
end two_to_one_multiplixer;


architecture multiplixer_logic of two_to_one_multiplixer is   -- creates logic for the two to one multiplixer

begin

	with multiplixer_select select								-- shows what values are selected when the select if different values
	multiplixer_output <= multiplixer_input_a when '0',	-- when select value is 0, the multiplixer input a is the output
								 multiplixer_input_b when '1';	-- when select value is 1, the multiplixer input b is the output
				  
				  
end multiplixer_logic;