--DEFINE SERVICES--
local ServerScriptService = game:GetService("ServerScriptService")



--REQUIRE MODULES--
local GameModule = require(ServerScriptService.Modules.GameModule)



--MAIN LOOP--
GameModule.Round:LoadObjectives()
GameModule.Round:Intermission()
