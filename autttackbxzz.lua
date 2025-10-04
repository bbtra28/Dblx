-- HuntyZombie v4 (fix: reliable Show/Hide + teleport-open + fast autofarm)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Jika GUI versi lama masih ada, buang dulu
if LocalPlayer:FindFirstChild("PlayerGui") then
    local old = LocalPlayer.PlayerGui:FindFirstChild("HuntyZombieV4")
    if old then old:Destroy() end
end

-- Status
local AutoFarm = false
local AutoOpen = false
local FarmConnection, OpenConnection

-- Cari zombie terdekat
local function GetNearestZombie()
    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return nil end
    local nearest, dist = nil, math.huge
    for _, mob in ipairs(Workspace:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            local d = (char.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = mob
            end
        end
    end
    return nearest
end

-- AutoFarm (per-frame)
local function StartAutoFarm()
    AutoFarm = true
    if FarmConnection then FarmConnection:Disconnect() end
    FarmConnection = RunService.Heartbeat:Connect(function()
        if not AutoFarm then return end
        local char = LocalPlayer.Character
        if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
        local target = GetNearestZombie()
        if target and target:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            root.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            -- spam click kecil tiap frame
            for i = 1, 5 do
                pcall(function() VirtualUser:ClickButton1(Vector2.new()) end)
            end
        end
    end)
end

local function StopAutoFarm()
    AutoFarm = false
    if FarmConnection then FarmConnection:Disconnect() FarmConnection = nil end
end

-- AutoOpen pakai teleport (per-frame). Teleport -> wait sedikit -> fire prompt
local function StartAutoOpen()
    AutoOpen = true
    if OpenConnection then OpenConnection:Disconnect() end
    OpenConnection = RunService.Heartbeat:Connect(function()
        if not AutoOpen then return end
        local char = LocalPlayer.Character
        if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
        local root = char.HumanoidRootPart
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if not AutoOpen then break end
            if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Enabled then
                local targetPart
                if prompt.Parent:IsA("BasePart") then
                    targetPart = prompt.Parent
                else
                    targetPart = prompt.Parent:FindFirstChildWhichIsA("BasePart")
                end
                if targetPart then
                    -- teleport sedikit di atas part supaya tidak terjebak di dalamnya
                    root.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0))
                    task.wait(0.03)
                    pcall(function() fireproximityprompt(prompt) end)
                    task.wait(0.02) -- jeda kecil antar prompt
                end
            end
        end
    end)
end

local function StopAutoOpen()
    AutoOpen = false
    if OpenConnection then OpenConnection:Disconnect() OpenConnection = nil end
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "HuntyZombieV4"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.5, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Parent = gui
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🌀 HuntyZombie v4"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Parent = frame

-- Tombol AutoFarm
local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1, -20, 0, 35)
farmBtn.Position = UDim2.new(0, 10, 0, 40)
farmBtn.Text = "AutoFarm: OFF"
farmBtn.Font = Enum.Font.Gotham
farmBtn.TextSize = 14
farmBtn.TextColor3 = Color3.new(1, 1, 1)
farmBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
farmBtn.Parent = frame
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 8)

farmBtn.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    farmBtn.Text = AutoFarm and "AutoFarm: ON" or "AutoFarm: OFF"
    farmBtn.BackgroundColor3 = AutoFarm and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
    if AutoFarm then StartAutoFarm() else StopAutoFarm() end
end)

-- Tombol AutoOpen
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(1, -20, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0, 85)
openBtn.Text = "Teleport Open Doors: OFF"
openBtn.Font = Enum.Font.Gotham
openBtn.TextSize = 14
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.Parent = frame
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

openBtn.MouseButton1Click:Connect(function()
    AutoOpen = not AutoOpen
    openBtn.Text = AutoOpen and "Teleport Open Doors: ON" or "Teleport Open Doors: OFF"
    openBtn.BackgroundColor3 = AutoOpen and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
    if AutoOpen then StartAutoOpen() else StopAutoOpen() end
end)

-- ShowButton dibuat SEKALI (tidak di-create ulang)
local showBtn = Instance.new("TextButton")
showBtn.Name = "ShowButton"
showBtn.Size = UDim2.new(0, 80, 0, 30)
showBtn.Position = UDim2.new(0, 20, 0.8, 0)
showBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
showBtn.TextColor3 = Color3.new(1, 1, 1)
showBtn.Text = "Show GUI"
showBtn.Font = Enum.Font.Gotham
showBtn.TextSize = 14
showBtn.Parent = gui
Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 8)
showBtn.Visible = false
showBtn.Active = true
showBtn.Draggable = true
showBtn.ZIndex = 10

showBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    showBtn.Visible = false
end)

-- Tombol Hide (di frame)
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 80, 0, 30)
hideBtn.Position = UDim2.new(0.5, -40, 1, 10)
hideBtn.Text = "Hide"
hideBtn.Font = Enum.Font.Gotham
hideBtn.TextSize = 14
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hideBtn.Parent = frame
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 8)

local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    frame.Visible = not hidden
    showBtn.Visible = hidden
end)
