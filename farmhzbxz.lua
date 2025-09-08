-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Player references
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local flyY = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true

-- Fly Button
local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 40)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.TextScaled = true
Instance.new("UICorner", flyButton)

-- Noclip Button
local noclipButton = Instance.new("TextButton", mainFrame)
noclipButton.Size = UDim2.new(1, -20, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 90)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.TextScaled = true
Instance.new("UICorner", noclipButton)

-- Tombol naik/turun (draggable)
local controlFrame = Instance.new("Frame", screenGui)
controlFrame.Size = UDim2.new(0, 70, 0, 140)
controlFrame.Position = UDim2.new(0.85, 0, 0.6, 0)
controlFrame.BackgroundTransparency = 1
controlFrame.Active = true
controlFrame.Draggable = true

local upBtn = Instance.new("TextButton", controlFrame)
upBtn.Size = UDim2.new(1, 0, 0.45, -5)
upBtn.Position = UDim2.new(0, 0, 0, 0)
upBtn.Text = "▲"
upBtn.BackgroundColor3 = Color3.fromRGB(50,200,50)
upBtn.TextColor3 = Color3.new(1,1,1)
upBtn.TextScaled = true
Instance.new("UICorner", upBtn)

local downBtn = Instance.new("TextButton", controlFrame)
downBtn.Size = UDim2.new(1, 0, 0.45, -5)
downBtn.Position = UDim2.new(0, 0, 0.55, 0)
downBtn.Text = "▼"
downBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
downBtn.TextColor3 = Color3.new(1,1,1)
downBtn.TextScaled = true
Instance.new("UICorner", downBtn)

-- FPS Counter
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 200, 0, 50)
fpsLabel.Position = UDim2.new(1, -210, 0, 10)
fpsLabel.BackgroundTransparency = 0.3
fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Text = "FPS: 0"
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", fpsLabel)

-- FPS Checker
local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(frameCount)
        frameCount = 0
        lastTime = currentTime
    end
end)

-- Handle tekan/lepas tombol naik turun
upBtn.MouseButton1Down:Connect(function() flyY = 1 end)
upBtn.MouseButton1Up:Connect(function() flyY = 0 end)
downBtn.MouseButton1Down:Connect(function() flyY = -1 end)
downBtn.MouseButton1Up:Connect(function() flyY = 0 end)

-- Fly function
local flyBodyVelocity
local flyBodyGyro

local function startFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Parent = HumanoidRootPart

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9000
    flyBodyGyro.CFrame = HumanoidRootPart.CFrame
    flyBodyGyro.Parent = HumanoidRootPart

    task.spawn(function()
        while flyEnabled and player.Character do
            local camCF = Workspace.CurrentCamera.CFrame
            local moveDir = Humanoid.MoveDirection

            -- Tambah naik/turun
            moveDir = Vector3.new(moveDir.X, flyY, moveDir.Z)

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * flySpeed
            end

            flyBodyVelocity.Velocity = moveDir
            flyBodyGyro.CFrame = camCF

            RunService.Heartbeat:Wait()
        end

        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end)
end

-- Noclip function
local function startNoclip()
    task.spawn(function()
        while noclipEnabled and player.Character do
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            RunService.Stepped:Wait()
        end
    end)
end

-- Button connections
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly: ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(50,200,50)
        startFly()
    else
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipButton.Text = "Noclip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(50,200,50)
        startNoclip()
    else
        noclipButton.Text = "Noclip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    end
end)
