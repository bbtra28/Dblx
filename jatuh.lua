-- LocalScript
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoFallGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Text = "No Fall Damage"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = mainFrame

-- Logic
local noFallEnabled = false
local connections = {}

local function enableNoFall()
    connections["State"] = humanoid.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Freefall then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        elseif new == Enum.HumanoidStateType.Landed then
            humanoid.Health = humanoid.MaxHealth
        end
    end)

    connections["Health"] = humanoid.HealthChanged:Connect(function(hp)
        if hp < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

local function disableNoFall()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    connections = {}
end

toggleButton.MouseButton1Click:Connect(function()
    noFallEnabled = not noFallEnabled
    if noFallEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        enableNoFall()
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        disableNoFall()
    end
end)