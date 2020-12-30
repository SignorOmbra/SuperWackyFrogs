--DEFINE MODULE--
local SetStrings = {}



--DEFINE SERVICES--
local ReplicatedStorage = game.ReplicatedStorage



--DEFINE VARIABLES--
local Values = ReplicatedStorage.Values
local Status = Values.Status
local Time = Values.Time



--DEFINE FUNCTIONS--
function SetStrings:ResetTime() 
	Time.Value = "" 
end

function SetStrings:ResetStatus() 
	Status.Value = "" 
end

function SetStrings:SetTime(String)
	Time.Value = String
end

function SetStrings:SetStatus(String)
	Status.Value = String
end



--RETURN MODULE--
return SetStrings