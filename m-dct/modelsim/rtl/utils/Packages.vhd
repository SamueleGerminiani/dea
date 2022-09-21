--! @file Packages.vhd
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
use ieee.numeric_std.all;

package ImageBlockType is 
	type image_vector is array (0 to 7) of std_logic_vector(7 downto 0);
	type image_block is array (0 to 7) of image_vector;

	type dct_vector is array (0 to 7) of std_logic_vector(15 downto 0);
	type dct_block is array (0 to 7) of dct_vector;
end package;

package InexactCellType is 
	type Inexact_cell_type is (FullAdder,cell_AMA1, cell_AMA2, cell_AMA3, cell_AMA4, cell_AXA1, cell_AXA2, cell_AXA3, cell_InAx1, cell_InAx2, cell_InAx3);
end package;

package AlgorithmType is 
	type algorithm_type is (BC12, CB11, BAS08, BAS09, BAS11, PEA12, PEA14);
end package;

package TestBenchUtils is 
	type int_array is array(integer range <>) of integer;
	type int_image_vector is array(0 to 8) of integer;
	type int_image_block is array(0 to 8) of int_image_vector;
end package;