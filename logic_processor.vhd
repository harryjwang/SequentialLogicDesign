-- Author: Group 10, Albert Zhou, Harry Wang 
library ieee;
use ieee.std_logic_1164.all;

entity logic_processor is
port(
	logic_in0, logic_in1 : in std_logic_vector(3 downto 0);		-- two logic inputs, 0 and 1 that is shown in the form of a vector	
	processor_select		: in std_logic_vector( 1 downto 0);		-- select value for the processor (vector with either 00, 01, 10, and 11)
	logic_out				: out std_logic_vector(3 downto 0) 		-- logic output value that returns a vector that depicts which lights are on
																					-- (if the output value is 1, then the light is turned on while if it's 0 the light is off)
);

end logic_processor;

architecture processor_logic of logic_processor is 

begin

-- 
	with processor_select(1 downto 0) select
	logic_out <= 
				  (logic_in0 AND logic_in1) when "00",			-- if the select is "00", then you compare the two logic inputs using AND logic
				  (logic_in0 OR logic_in1) when "01",			-- if the select if "01", then you compare the two logic inputs using OR logic
				  (logic_in0 XOR logic_in1) when "10",			-- if the select if "10", then you compare the two logic inputs using XOR logic
				  (logic_in0 XNOR logic_in1) when "11";		-- if the select if "11", then you compare the two logic inputs using XNOR logic
				  
end processor_logic;
