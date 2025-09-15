-- Author: Group 10, Albert Zhou, Harry Wang 
library ieee;
use ieee.std_logic_1164.all;

ENTITY PB_Inverters IS
	PORT 
	(
		pb_n : IN std_logic_vector(3 downto 0);	 -- sets the original state of the push buttons where the underscore ("_") shows us that the push buttons are usually
																 -- in a active low state
																 
		pb : OUT std_logic_vector(3 downto 0)		 -- output of the new push button that we want to get. we want this output to be in active high and therefore is why
																 -- the variable with no undresacore which shows us that the new push button output is in active high
	);
END PB_Inverters;

ARCHITECTURE gates OF PB_Inverters IS

BEGIN

pb <= not(pb_n);   -- flips the push button so that when the button is pressed, the button enters an "on" state while when it's not pressed the button is in an "off" state
						 -- originally, the push buttons are active low (pressing the button turns it off (changes to 0)). However, we want the push buttons to be in a way
						 -- where if we press the buttons, the state of the button changes to 1. To do this, we use an inverter (a not statement) where we change the push
						 -- buttons from active low to active high and therefore that allows us to change the state of the push buttons from 0 to 1 by pushing the corresponding button
END gates;