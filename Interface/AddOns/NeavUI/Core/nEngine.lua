----------------------------------
-- Engine to make all files communicate.

-- Credit Nightcracker
----------------------------------
 
-- including system
local addon, engine = ...
engine[1] = {} -- N, functions, constants
engine[2] = {} -- C, config

NeavUI = engine --Allow other addons to use Engine

--[[
	This should be at the top of every file inside of the NeavUI AddOn:
	
	local N, C = unpack(select(2, ...))

	This is how another addon imports the NeavUI engine:
	
	local N, C = unpack(NeavUI)
]]