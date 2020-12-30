local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    for i, Conveyor in pairs(workspace.Conveyors:GetChildren()) do
        Conveyor.Velocity = Conveyor.CFrame.lookVector * 90
    end
end)
