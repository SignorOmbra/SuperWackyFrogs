--DEFINE SERVICES--



--DEFINE VARIABLES--
local Character = script.Parent
local Humanoid = Character:FindFirstChildOfClass("Humanoid")



--EVENT SUBSCRIPTION--
Humanoid.Touched:Connect(function(Part, Limb)
    if Part.Name == "KillPart" and script.Parent.Humanoid.Health > 0 then
        Humanoid.Health = 0
    end
end)