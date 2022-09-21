--! @file FullAdder.vhd
--!
--! @author	Andrea Aletto <andrea.aletto8@gmail.com>
--! 
--! @copyright
--! Copyright 2017-2019	Andrea Aletto <andrea.aletto8@gmail.com>
--! 
--! This file is part of AxC-Adders_vhdl
--! 
--! AxC-Adders_vhdl is free software; you can redistribute it and/or modify it under
--! the terms of the GNU General Public License as published by the Free
--! Software Foundation; either version 3 of the License, or any later version.
--! 
--! AxC-Adders_vhdl is distributed in the hope that it will be useful, but WITHOUT
--! ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
--! FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
--! more details.
--! 
--! You should have received a copy of the GNU General Public License along with
--! RMEncoder; if not, write to the Free Software Foundation, Inc., 51 Franklin
--! Street, Fifth Floor, Boston, MA 02110-1301, USA.

library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
    port 
    (	
		--! Primo addendo
		add_1 : in std_logic;
		--! Secondo addendo
		add_2 : in std_logic;
		--! Eventuale carry in ingresso da una precedente somma
		carry_in  : in std_logic;
		--! Carry generato per la somma successiva
		carry_out : out std_logic;
		--! Somma
		sum : out std_logic
	);
end FullAdder;

architecture FullAdder of FullAdder is
begin
	carry_out <= (add_1 and add_2) or (carry_in and (add_1 xor add_2));
	sum <= add_1 xor add_2 xor carry_in;
end architecture;

