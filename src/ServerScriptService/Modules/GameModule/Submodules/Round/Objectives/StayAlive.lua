--DEFINE OBJECTIVE--
local StayAlive = {}



--DEFINE SERVICES--
local Players = game.Players



--DEFINE VARIABLES--
local Connections = {}
local PlayersInRound = 0



--DEFINE FUNCTIONS--
function StayAlive:StartObjective()
    for i, Player in pairs(Players:GetPlayers()) do
        if Player.InRound.Value == true then
            local Character = Player.Character
            Player.Succeeded.Value = true
            PlayersInRound = PlayersInRound + 1

            Connections[Player.Name] = Character.Humanoid.Died:Connect(function()
                Player.Succeeded.Value = false
                Player.InRound.Value = false
                PlayersInRound = PlayersInRound - 1

                if PlayersInRound <= 0 then
                    game.ReplicatedStorage.Values.Failed.Value = true
                end

                Connections[Player.Name]:Disconnect()
            end)
        end
    end
end

function StayAlive:EndObjective()
    for i, Connection in pairs(Connections) do
        Connection:Disconnect()
    end
end



--RETURN OBJECTIVE--
return StayAlive