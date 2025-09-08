-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Player references
local player = Players.LocalPlayer
local Character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local lowGraphicsEnabled = false
local currentFPS = 0
local guiVisible = true

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 190)
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

-- Tombol Hide/Show (pakai tulisan)
local hideButton = Instance.new("TextButton", mainFrame)
hideButton.Size = UDim2.new(0, 60, 0, 30)
hideButton.Position = UDim2.new(1, -65, 0, 5)
hideButton.Text = "Hide"
hideButton.TextScaled = true
hideButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
hideButton.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideButton)

-- Tombol Fly
local flyButton = Instance.new("TextButton", mainFrame)
flyButton.Size = UDim2.new(1, -20, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 40)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.TextScaled = true
Instance.new("UICorner", flyButton)

-- Tombol Noclip
local noclipButton = Instance.new("TextButton", mainFrame)
noclipButton.Size = UDim2.new(1, -20, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 90)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.TextScaled = true
Instance.new("UICorner", noclipButton)

-- Tombol Low Graphics
local lowGfxButton = Instance.new("TextButton", mainFrame)
lowGfxButton.Size = UDim2.new(1, -20, 0, 40)
lowGfxButton.Position = UDim2.new(0, 10, 0, 140)
lowGfxButton.Text = "Low GFX: OFF"
lowGfxButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
lowGfxButton.TextColor3 = Color3.new(1,1,1)
lowGfxButton.TextScaled = true
Instance.new("UICorner", lowGfxButton)

-- FPS Label (diperkecil font)
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 120, 0, 20)
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.BackgroundTransparency = 0.5
fpsLabel.BackgroundColor3 = Color3.new(0,0,0)
fpsLabel.Text = "FPS: 0"
fpsLabel.TextSize = 14
fpsLabel.TextScaled = false

-- Tombol naik & turun Y (tetap terlihat walau GUI di-hide)
local controlFrame = Instance.new("Frame", screenGui)
controlFrame.Size = UDim2.new(0, 100, 0, 100)
controlFrame.Position = UDim2.new(0.8, 0, 0.65, 0)
controlFrame.BackgroundTransparency = 1
controlFrame.Active = true
controlFrame.Draggable = true

local function createButton(name, pos, text)
    local btn = Instance.new("TextButton", controlFrame)
    btn.Name = name
    btn.Size = UDim2.new(0, 40, 0, 40) -- diperkecil
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.TextScaled = true
    Instance.new("UICorner", btn)
    return btn
end

local upYBtn = createButton("UpY", UDim2.new(0, 0, 0, 0), "↑")
local downYBtn = createButton("DownY", UDim2.new(0, 0, 0.5, 0), "↓")

local controlState = { UpY = false, DownY = false }

local function bindButton(btn, key)
    btn.MouseButton1Down:Connect(function() controlState[key] = true end)
    btn.MouseButton1Up:Connect(function() controlState[key] = false end)
end
bindButton(upYBtn, "UpY")
bindButton(downYBtn, "DownY")

-- Fly
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
            local moveDirection = Humanoid.MoveDirection

            if controlState.UpY then
                moveDirection += Vector3.new(0, 1, 0)
            end
            if controlState.DownY then
                moveDirection -= Vector3.new(0, 1, 0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end

            flyBodyVelocity.Velocity = moveDirection
            flyBodyGyro.CFrame = Workspace.CurrentCamera.CFrame

            RunService.Heartbeat:Wait()
        end

        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end)
end

-- Noclip
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

-- Low Graphics
local function setLowGraphics(state)
    if state then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
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

lowGfxButton.MouseButton1Click:Connect(function()
    lowGraphicsEnabled = not lowGraphicsEnabled
    if lowGraphicsEnabled then
        lowGfxButton.Text = "Low GFX: ON"
        lowGfxButton.BackgroundColor3 = Color3.fromRGB(50,200,50)
        setLowGraphics(true)
    else
        lowGfxButton.Text = "Low GFX: OFF"
        lowGfxButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
        setLowGraphics(false)
    end
end)

-- Hide button toggle (pakai tulisan)
hideButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    for _, obj in pairs(screenGui:GetChildren()) do
        if obj ~= fpsLabel and obj ~= hideButton and obj ~= controlFrame then
            obj.Visible = guiVisible
        end
    end
    hideButton.Text = guiVisible and "Hide" or "Show"
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
        fpsLabel.Text = "FPS: " .. tostring(currentFPS)
    end
end)
