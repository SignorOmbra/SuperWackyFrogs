--DEFINE MODULE--
local InitPlayer = {}



--DEFINE SERVICES--
local Players = game.Players
local DataStoreService = game:GetService("DataStoreService")



--DEFINE VARIABLES--
local LobbySpawns = workspace.Spawns:GetChildren()



--DEFINE FUNCTIONS--
function InitPlayer:CreateValue(Player, ValueType, Name, Value)
    local NewValue = Instance.new(ValueType)
    NewValue.Parent = Player
    NewValue.Name = Name
    NewValue.Value = Value

    return NewValue
end



--DEFINE CONNECTIONS--
Players.PlayerAdded:Connect(function(Player)
    local Succeeded = InitPlayer:CreateValue(
        Player, 
        "BoolValue", 
        "Succeeded",
        false
    )

    local InRound = InitPlayer:CreateValue(
        Player, 
        "BoolValue", 
        "InRound",
        false
    )

    print("Player joined: " .. Player.Name)
end)

Players.PlayerRemoving:Connect(function(Player)
    print("Player left: " .. Player.Name)
end)



--RETURN MODULE--
return InitPlayer