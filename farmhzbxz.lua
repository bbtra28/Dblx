--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

--// Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Zombie Farm GUI", "DarkTheme")

--// State
local autoSkillEnabled = false
local autofarm = false
local magnetEnabled = false
local infiniteJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local currentFPS = 0
local positionLabel, fpsLabel

--// TweenInfo
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

--// Skill Sender
local function fireSkill(skillCode)
    local ok, err = pcall(function()
        local args = { buffer.fromstring(skillCode) } -- executor support buffer
        local remote = ReplicatedStorage:FindFirstChild("ByteNetReliable")
        if remote then remote:FireServer(unpack(args)) end
    end)
    if not ok then warn("Skill error:", err) end
end

local function autoSkillLoop()
    while autoSkillEnabled do
        fireSkill("\b\003\000") -- Z
        task.wait(0.1)
        fireSkill("\b\005\000") -- X
        task.wait(0.1)
        fireSkill("\b\006\000") -- C
        task.wait(0.1)
        fireSkill("\b\007\000") -- G
        task.wait(0.1)
        fireSkill("\f")         -- E
        task.wait(0.1)
    end
end

--// Auto Attack
local function autoAttack()
    local ok, err = pcall(function()
        local args = { buffer.fromstring("\b\004\000") }
        local remote = ReplicatedStorage:FindFirstChild("ByteNetReliable")
        if remote then remote:FireServer(unpack(args)) end
    end)
    if not ok then warn("Attack error:", err) end
end

--// Cari zombie terdekat
local function getNearbyEntities(range)
    local entities = {}
    local folder = Workspace:FindFirstChild("Entities")
    if not folder then return entities end

    for _, mob in pairs(folder:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
            local root = mob.HumanoidRootPart
            local hum = mob:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (HumanoidRootPart.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(entities, {Root = root, Hum = hum, Model = mob, Dist = dist})
                end
            end
        end
    end

    table.sort(entities, function(a,b) return a.Dist < b.Dist end)
    return entities
end

--// Smooth Teleport
local function smoothTeleport(cf)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

--// Farm Routine
local function farmRoutine()
    while autofarm do
        local list = getNearbyEntities(250)
        if #list == 0 then task.wait(1) continue end
        local target = list[1]

        smoothTeleport(target.Root.CFrame + Vector3.new(0,8,0))

        while autofarm and target.Hum and target.Hum.Health > 0 do
            HumanoidRootPart.CFrame = CFrame.new(
                target.Root.Position + Vector3.new(0,6,0),
                target.Root.Position
            )
            autoAttack()
            task.wait(0.2)
        end
    end
end

--// Magnet Loop
local function magnetLoop()
    while magnetEnabled do
        local folder = Workspace:FindFirstChild("Entities")
        if folder then
            for _, mob in pairs(folder:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                    local root = mob.HumanoidRootPart
                    local hum = mob:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        local dist = (HumanoidRootPart.Position - root.Position).Magnitude
                        if dist <= 100 then
                            root.CFrame = HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
                        end
                    end
                end
            end
        end
        task.wait(0.2)
    end
end

--// Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// Fly
local flyBodyVelocity, flyBodyGyro
local function startFly()
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyBodyVelocity.Parent = HumanoidRootPart

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    flyBodyGyro.P = 9000
    flyBodyGyro.Parent = HumanoidRootPart

    Humanoid.PlatformStand = true

    task.spawn(function()
        while flyEnabled do
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

            if move.Magnitude > 0 then move = move.Unit * flySpeed end
            flyBodyVelocity.Velocity = move
            flyBodyGyro.CFrame = Workspace.CurrentCamera.CFrame
            task.wait()
        end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        Humanoid.PlatformStand = false
    end)
end

--// Noclip
local function toggleNoclip(state)
    if state then
        task.spawn(function()
            while noclipEnabled do
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                RunService.Stepped:Wait()
            end
        end)
    end
end

--// FPS Info
local lastTime, frameCount = tick(), 0
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        currentFPS = frameCount
        frameCount = 0
        lastTime = now
        if fpsLabel then fpsLabel.Text = "Current FPS: " .. tostring(currentFPS) end
    end
end)

RunService.Heartbeat:Connect(function()
    if positionLabel then
        local pos = HumanoidRootPart.Position
        positionLabel.Text = string.format("Current Location: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z)
    end
end)

--// FPS Optimizer
local function improveFPS()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then v.Enabled = false end
        if v:IsA("MeshPart") or v:IsA("UnionOperation") then v.Material = Enum.Material.SmoothPlastic end
    end
end

--// UI Tabs
local autoSkillTab = Window:NewTab("Auto Skill")
autoSkillTab:NewToggle("Enable Auto Skill", "Spam skill Z/X/C/G/E", function(v)
    autoSkillEnabled = v
    if v then task.spawn(autoSkillLoop) end
end)

local autoFarmTab = Window:NewTab("Auto Farm")
autoFarmTab:NewToggle("Enable Auto Farm", "TP ke zombie + auto attack", function(v)
    autofarm = v
    if v then task.spawn(farmRoutine) end
end)

autoFarmTab:NewToggle("Magnet Zombie", "Tarik zombie ke dekat player", function(v)
    magnetEnabled = v
    if v then task.spawn(magnetLoop) end
end)

local flyTab = Window:NewTab("Fly")
flyTab:NewToggle("Enable Fly", "Terbang WASD + Space/Ctrl", function(v)
    flyEnabled = v
    if v then startFly() end
end)
flyTab:NewSlider("Fly Speed", "Atur kecepatan fly", 500, 1, function(val) flySpeed = val end)

local noclipTab = Window:NewTab("Noclip")
noclipTab:NewToggle("Enable Noclip", "Tembus tembok", function(v)
    noclipEnabled = v
    toggleNoclip(v)
end)

local jumpTab = Window:NewTab("Infinite Jump")
jumpTab:NewToggle("Enable Infinite Jump", "Lompat tanpa batas", function(v) infiniteJumpEnabled = v end)

local infoTab = Window:NewTab("Info")
positionLabel = infoTab:NewLabel("Current Location: Loading...")
fpsLabel = infoTab:NewLabel("Current FPS: Loading...")

local fpsTab = Window:NewTab("FPS")
fpsTab:NewButton("Improve FPS", "Boost FPS", function() improveFPS() end)

--// Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
end)
