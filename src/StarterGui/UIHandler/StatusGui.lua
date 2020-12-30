local StatusGuiHandler = {}



--DEFINE SERVICES--
local ReplicatedStorage = game.ReplicatedStorage
local Players = game.Players



--REQUIRE MODULES--
local Flipper = require(ReplicatedStorage:WaitForChild("Flipper"))



--DEFINE VARIABLES--
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Values = ReplicatedStorage.Values



--DEFINE UI ELEMENTS--
local StatusGui = PlayerGui:WaitForChild("StatusGui")
local StatusText = StatusGui.Status
local TimeText = StatusGui.Time



--SPRING SETUP--
local TimeSpringSettings  = {
    frequency = 3,
	dampingRatio = 1
}

local TimeMotor = Flipper.GroupMotor.new({
    X = 0.421,
    Y = 0.143,
    W = 0.157,
    H = 0.133
})

local StatusMotor = Flipper.GroupMotor.new({
    X = 0.083,
    Y = 0.054,
    W = 0.832,
    H = 0.089
})

local TimeColorMotor = Flipper.GroupMotor.new({
    R = 255,
    G = 255,
    B = 255
})



--ANIMATOR FUNCTIONS--
local function AnimateStatus()
    StatusMotor:setGoal({
        X = Flipper.Spring.new(0, TimeSpringSettings),
        Y = Flipper.Spring.new(0.037, TimeSpringSettings),
        W = Flipper.Spring.new(1, TimeSpringSettings),
        H = Flipper.Spring.new(0.106, TimeSpringSettings)
    })

    wait(0.4)

    StatusMotor:setGoal({
        X = Flipper.Spring.new(0.083, TimeSpringSettings),
        Y = Flipper.Spring.new(0.054, TimeSpringSettings),
        W = Flipper.Spring.new(0.832, TimeSpringSettings),
        H = Flipper.Spring.new(0.089, TimeSpringSettings)
    })
end

local function AnimateTime()
    TimeMotor:setGoal({
        X = Flipper.Spring.new(0.386, TimeSpringSettings),
        Y = Flipper.Spring.new(0.123, TimeSpringSettings),
        W = Flipper.Spring.new(0.224, TimeSpringSettings),
        H = Flipper.Spring.new(0.188, TimeSpringSettings)
    })
    TimeColorMotor:setGoal({
        R = Flipper.Spring.new(255, TimeSpringSettings),
        G = Flipper.Spring.new(65, TimeSpringSettings),
        B = Flipper.Spring.new(65, TimeSpringSettings)
    })

    wait(0.4)

    TimeMotor:setGoal({
        X = Flipper.Spring.new(0.421, TimeSpringSettings),
        Y = Flipper.Spring.new(0.143, TimeSpringSettings),
        W = Flipper.Spring.new(0.157, TimeSpringSettings),
        H = Flipper.Spring.new(0.133, TimeSpringSettings)
    })
    TimeColorMotor:setGoal({
        R = Flipper.Spring.new(255, TimeSpringSettings),
        G = Flipper.Spring.new(255, TimeSpringSettings),
        B = Flipper.Spring.new(255, TimeSpringSettings)
    })
end



--GET ANIMATOR OBJECTS--
--local TimeAnimator = require(TimeText.Animator)



--EVENT SUBSCRIPTION AND VALUES--
TimeMotor:onStep(function(Values)
    TimeText.Position = UDim2.fromScale(Values.X, Values.Y)
    TimeText.Size = UDim2.fromScale(Values.W, Values.H)
end)

StatusMotor:onStep(function(Values)
    StatusText.Position = UDim2.fromScale(Values.X, Values.Y)
    StatusText.Size = UDim2.fromScale(Values.W, Values.H)
end)

TimeColorMotor:onStep(function(Values)
    TimeText.TextColor3 = Color3.fromRGB(Values.R, Values.G, Values.B)
end)

StatusText.Text = Values.Status.Value

Values.Status.Changed:Connect(function(NewValue)
    StatusText.Text = NewValue
    AnimateStatus()
end)

TimeText.Text = Values.Time.Value

Values.Time.Changed:Connect(function(NewValue)
    TimeText.Text = NewValue

    if tonumber(TimeText.Text) then
        if tonumber(TimeText.Text) <= 10 then
            AnimateTime()
        end
    end
    --TimeAnimator.Update:Play()
end)



return StatusGuiHandler