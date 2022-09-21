--! @file RippleCarry.vhd
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

library work;
use work.InexactCellType.all;

entity RippleCarry is
	generic
	(
		--! Lunghezza, in termini di bit, degli addendi da sommare.
		nbits : natural := 16;

		--! Numero di bit approssimati
		nab : natural := 0;

		--! Tipo di cella addizionatore
		cell_type : Inexact_cell_type := cell_AMA1
	);
    port 
    (
		--! Primo addendo
		add_1 : in std_logic_vector (nbits-1 downto 0);
		--! Secondo addendo
		add_2 : in std_logic_vector (nbits-1 downto 0);
		--! Eventuale carry in ingresso da una precedente somma
		carry_in : in std_logic;
		--! Carry generato per la somma successiva
		carry_out : out std_logic;
		--! Somma
		sum : out std_logic_vector (nbits-1 downto 0)
	);
end RippleCarry;


architecture RippleCarry of RippleCarry is

	component FullAdder is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AMA1 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AMA2 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AMA3 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AMA4 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AXA1 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AXA2 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component AXA3 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component InAx1 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component InAx2 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;

	component InAx3 is
    port (	add_1 : in std_logic; add_2 : in std_logic; carry_in  : in std_logic; carry_out : out std_logic; sum : out std_logic );
	end component;


	signal tmp_carry : std_logic_vector (nbits downto 0) := (others => '0');

begin

	tmp_carry(0) <= carry_in;
	carry_out <= tmp_carry(nbits);

	FullAdder_waterfall: for i in nbits-1 downto nab generate
	FullAdder_inst : FullAdder
	port map
	(
		add_1 => add_1(i),
		add_2 => add_2(i),
		carry_in => tmp_carry(i),
		carry_out => tmp_carry(i+1),
		sum => sum(i)
	);
	end generate;

	Inexact_waterfall: for i in nab-1 downto 0 generate 
		AMA1_cell: if cell_type = cell_AMA1 generate
		Inexact_inst : AMA1
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AMA2_cell: if cell_type = cell_AMA2 generate
		Inexact_inst : AMA2
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AMA3_cell: if cell_type = cell_AMA3 generate
		Inexact_inst : AMA3
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AMA4_cell: if cell_type = cell_AMA4 generate
		Inexact_inst : AMA4
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AXA1_cell: if cell_type = cell_AXA1 generate
		Inexact_inst : AXA1
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AXA2_cell: if cell_type = cell_AXA2 generate
		Inexact_inst : AXA2
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		AXA3_cell: if cell_type = cell_AXA3 generate
		Inexact_inst : AXA3
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		InAx1_cell: if cell_type = cell_InAx1 generate
		Inexact_inst : InAx1
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		InAx2_cell: if cell_type = cell_InAx2 generate
		Inexact_inst : InAx2
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		InAx3_cell: if cell_type = cell_InAx3 generate
		Inexact_inst : InAx3
		port map
		(
			add_1 => add_1(i),
			add_2 => add_2(i),
			carry_in => tmp_carry(i),
			carry_out => tmp_carry(i+1),
			sum => sum(i)
		);
		end generate;

		
	end generate;

end architecture;



