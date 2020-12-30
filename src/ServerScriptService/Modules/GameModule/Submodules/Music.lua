--DEFINE MODULE--
local MusicModule = {}



--DEFINE SERVICES--
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game.ReplicatedStorage



--CHECK EXISTANCE OF OBJECTS--
local PlaybackObject = workspace:FindFirstChild("Music")

if not ReplicatedStorage:FindFirstChild("Resources") then
	error("No 'Resources' folder!")
elseif ReplicatedStorage:FindFirstChild("Resources") and not ReplicatedStorage:FindFirstChild("Resources"):FindFirstChild("MusicList") then
	error("No 'MusicList' folder!")
end

if not workspace:FindFirstChild("Music") then
	PlaybackObject = Instance.new("Sound")
	PlaybackObject.Parent = workspace
	PlaybackObject.Name = "Music"
end



--LOCAL VARIABLES--
local Resources = ReplicatedStorage.Resources
local Music = workspace.Music
local MusicList = Resources.MusicList

local LastSong = nil
local NewSong = nil



--FUNCTIONS--
function MusicModule:PlaySong(Song, LoopSong)
	PlaybackObject.SoundId = Song.SoundId
	PlaybackObject.PlaybackSpeed = Song.PlaybackSpeed
	PlaybackObject.Volume = 1

	if LoopSong then
		PlaybackObject.Looped = true
	else
		PlaybackObject.Looped = false
	end

	if PlaybackObject.Playing then
		PlaybackObject:Stop()
	end

	PlaybackObject:Play()

	local SoundId = string.sub(NewSong.SoundId, 14)
	local Asset = MarketplaceService:GetProductInfo(SoundId)

	return PlaybackObject
end

function MusicModule:PlayRandomSong()
	local Songs = MusicList:GetChildren()

	if #Songs >= 2 then
		repeat NewSong = Songs[math.random(1, #Songs)] until NewSong ~= LastSong and NewSong:IsA("Sound")

		LastSong = NewSong
		MusicModule:PlaySong(NewSong)

		return PlaybackObject
	else
		warn("MusicList must have two or more songs!")
	end
end

function MusicModule:StopSong()
	Music:Stop()
end

function MusicModule:FadeSong(FadeTime)
	local LowerTween = TweenService:Create(
		Music,
		TweenInfo.new(
			FadeTime,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
		),
		{
			Volume = 0
		}
	)

	LowerTween:Play()

	wait(FadeTime)

	return
end


--RETURN MODULE--
return MusicModule