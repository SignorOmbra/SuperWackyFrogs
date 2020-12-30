local Players = game.Players
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local TimesLagswitched = 0
local FPS

local AntiExploitString = "If you see this, please stop cheating. Up to you, though. :^)"

if FPS == "NotSupposedToSeeThis" then
    print(AntiExploitString)
end

RunService.RenderStepped:Connect(function(DeltaTime)
    FPS = math.floor(1 / DeltaTime + 0.5)

    if DeltaTime >= 0.7 and FPS <= 2 then
        if TimesLagswitched == 3 then
            print(FPS, DeltaTime)
            Player:Kick("Lagswitching detected! If you think this was a mistake, please contact the developers.")
        else
            TimesLagswitched = TimesLagswitched + 1 -- This is done due to Roblox loading, so you have to lag twice.
        end
    end
end)