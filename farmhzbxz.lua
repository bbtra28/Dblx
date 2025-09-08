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
local currentFPS = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Text = "Fly & Noclip GUI"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 40)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.TextScaled = true
Instance.new("UICorner", flyButton)

local noclipButton = Instance.new("TextButton", mainFrame)
noclipButton.Size = UDim2.new(1, -20, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 90)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.TextScaled = true
Instance.new("UICorner", noclipButton)

-- FPS Label
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 200, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.new(0,0,0)
fpsLabel.Text = "Current FPS: 0"
fpsLabel.TextScaled = true

-- Fly function (pakai analog + kamera)
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
            local moveDirection = Humanoid.MoveDirection

            if moveDirection.Magnitude > 0 then
                local camForward = camCF.LookVector
                local camRight = camCF.RightVector

                -- Ambil input analog (X/Z) lalu ikuti arah kamera
                local x = moveDirection.X
                local z = moveDirection.Z
                moveDirection = (camForward * z + camRight * x).Unit * flySpeed
            else
                moveDirection = Vector3.zero
            end

            flyBodyVelocity.Velocity = moveDirection
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

-- FPS Checker
local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastTime = currentTime
        fpsLabel.Text = "Current FPS: " .. tostring(currentFPS)
    end
end)
