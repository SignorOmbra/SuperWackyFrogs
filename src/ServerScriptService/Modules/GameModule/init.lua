--[[
	     WACKY FROGS
	Written by SignorOmbra
	    Version 0.0.7
]]--



--DEFINE MODULE--
local GameModule = {}



--DEFINE VARIABLES--
local Submodules = script.Submodules:GetChildren()



--DEFINE FUNCTIONS--
function GameModule:LoadSubmodules()
	print("Attempting to load submodules. \n")

	for i, Submodule in pairs(Submodules) do
		print("Attempting to load module '" .. Submodule.Name .. "'. (" .. i .. ")")

		if not GameModule[Submodule.Name] then
			print("Requiring and adding to table...")

			GameModule[Submodule.Name] = require(Submodule)

			print("Loaded " .. Submodule.Name .. "! \n")
		end
	end

	print("Loaded all modules!")
end



--LOAD SUBMODULES--
GameModule:LoadSubmodules()



--RETURN MODULE--
return GameModule