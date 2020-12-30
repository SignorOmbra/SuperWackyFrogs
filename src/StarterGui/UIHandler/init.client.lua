--DEFINE VARIABLES--

local Handlers = script:GetChildren()
local LoadedHandlers = {}


--LOAD HANDLERS--
for i, Handler in pairs(Handlers) do
    if not LoadedHandlers[Handler.Name] then
        LoadedHandlers[Handler.Name] = require(Handler)
    end
end