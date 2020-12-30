--DEFINE MODULE--
local RoundModule = {}



--REQUIRE MODULES--
local Music = require(script.Parent.Music)
local SetStrings = require(script.SetStrings)



--DEFINE SERVICES--
local Players = game.Players
local ReplicatedStorage = game.ReplicatedStorage
local ServerStorage = game.ServerStorage
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")



--DEFINE VARIABLES--
local Values = ReplicatedStorage.Values
local Status = Values.Status
local Time = Values.Time
local Failed = Values.Failed
local Objectives = script.Objectives
local LoadedObjectives = {}

local LobbySpawns = workspace.Spawns:GetChildren()
local ElevatorGround = workspace.ElevatorGround
local CurrentObjective

local RandomGenerator = Random.new()
local Events = ServerStorage.Events:GetChildren()

local TotalCountdowns = 0



--DEFINE TABLES--
RoundModule.Settings = {
	RequiredPlayerCount = 1,
	IntermissionTime = 15 --26
}

RoundModule.RoundStatusCodes = {
	UnderMinPlayers = "%u or more players are needed to start!",
	IntermissionTimer = "Intermission!",
	ChoseEvent = "The event is '%s'!",
	Ready = "Get ready!",
	EventCompleted = "Event completed!",
	EventFailed = "Event failed!"
}



--DEFINE FUNCTIONS--
function RoundModule:CancelCountdown()
	TotalCountdowns = TotalCountdowns + 1 -- super hacky but im doing it anyways HAAAAAA
end

function RoundModule:Countdown(Time)
	for i = Time, 0, -1 do
		if Failed.Value == true then
			break
		end
		
		SetStrings:SetTime(tostring(i))
		wait(1)
	end

	return
end

function RoundModule:FindObjective(ObjectiveName)
	if Objectives:FindFirstChild(ObjectiveName) then
		return Objectives:FindFirstChild(ObjectiveName)
	else
		warn("Can't find objective " .. ObjectiveName .. ", using default (StayAlive).")
		return Objectives.StayAlive
	end
end

function RoundModule:LoadObjectives()
	for i, Objective in pairs(Objectives:GetChildren()) do
		if not LoadedObjectives[Objective.Name] then
			LoadedObjectives[Objective.Name] = require(Objective)
		end
	end
end

function RoundModule:Lower(Depth, Length)
	local LowerTween = TweenService:Create(
		ElevatorGround,
		TweenInfo.new(
			Length,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Position = Vector3.new(
				ElevatorGround.Position.X,
				-20.5 - Depth,
				ElevatorGround.Position.Z
			)
		}
	)

	LowerTween:Play()

	wait(Length)

	return
end

function RoundModule:BeginEvent()
	local ChosenEvent = Events[math.random(1, #Events)]
	local EventObject = ChosenEvent:Clone()
	print(ChosenEvent, Events, #Events)

	local Spawns = EventObject.Spawns:GetChildren()
	local StartBox = EventObject.StartBox
	local ObjectiveName = EventObject.Metadata.Objective.Value
	local Depth = EventObject.Metadata.Depth.Value
	local LowerTime = EventObject.Metadata.LowerTime.Value

	CurrentObjective = LoadedObjectives[ObjectiveName]
	EventObject.Parent = workspace.Event

	SetStrings:SetStatus(string.format(RoundModule.RoundStatusCodes.ChoseEvent, ChosenEvent.Name))
	
	wait(RoundModule:Lower(Depth, LowerTime))

	for i, Player in pairs(Players:GetPlayers()) do
		local Spawn = Spawns[math.random(1, #Spawns)]

		Player.Character.HumanoidRootPart.CFrame = Spawn.CFrame
		Player.InRound.Value = true

		Spawn:Destroy()
	end

	CurrentObjective:StartObjective()
	SetStrings:ResetTime()
	Music:FadeSong(1.5)

	wait(3)

	Status.Value = RoundModule.RoundStatusCodes.Ready
	Music:PlaySong(EventObject.EventMusic, true)

	wait(2)

	SetStrings:SetStatus(EventObject.Metadata.Instructions.Value)
	StartBox:Destroy()
	EventObject.Spawns:Destroy()
	
	RoundModule:Countdown(EventObject.Metadata.Time.Value)

	if Failed.Value == false then
		SetStrings:SetStatus(RoundModule.RoundStatusCodes.EventCompleted)
		SetStrings:ResetTime()

		for i, Player in pairs(Players:GetPlayers()) do
			if Player.InRound.Value == true then
				local LobbySpawn = LobbySpawns[math.random(1, #LobbySpawns)]

				Player.Character.HumanoidRootPart.CFrame = LobbySpawn.CFrame
				Player.InRound.Value = false
			end
		end

		EventObject:Destroy()
		RoundModule:Intermission()
	else
		SetStrings:SetStatus(RoundModule.RoundStatusCodes.EventFailed)
		SetStrings:ResetTime()

		Music:FadeSong(1.5)
		wait(5.3)

		EventObject:Destroy()
		RoundModule:Intermission()
	end
end

function RoundModule:Intermission()
	if CurrentObjective then
		CurrentObjective:EndObjective()
	end

	game.ReplicatedStorage.Values.Failed.Value = false

	Music:PlayRandomSong()

	SetStrings:SetStatus(RoundModule.RoundStatusCodes.IntermissionTimer)

	for i, Player in pairs(Players:GetPlayers()) do
		Player.InRound.Value = false
	end

	RoundModule:Lower(0, 3)
	RoundModule:Countdown(RoundModule.Settings.IntermissionTime)

	SetStrings:ResetTime()

	RoundModule:BeginEvent()
end



--RETURN MODULE--
return RoundModule