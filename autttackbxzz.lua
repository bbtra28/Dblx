-- 🟢 Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- 🟢 Status
local AutoFarm = false
local AutoOpen = false

-- 🟢 Fungsi cari zombie terdekat
local function GetNearestZombie()
    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end

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

-- 🟢 AutoFarm cepat
local function StartAutoFarm()
    AutoFarm = true
    task.spawn(function()
        while AutoFarm do
            task.wait(0.15)
            local target = GetNearestZombie()
            local char = LocalPlayer.Character
            if target and char and char:FindFirstChild("HumanoidRootPart") then
                -- Posisikan sedikit di belakang zombie agar tidak nabrak
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2.5)
                -- Klik lebih sering untuk DPS lebih tinggi
                for i = 1, 3 do
                    VirtualUser:ClickButton1(Vector2.new())
                end
            end
        end
    end)
end

local function StopAutoFarm()
    AutoFarm = false
end

-- 🟢 AutoOpen pintu cepat
local function StartAutoOpen()
    AutoOpen = true
    task.spawn(function()
        while AutoOpen do
            task.wait(0.2)
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    fireproximityprompt(prompt)
                end
            end
        end
    end)
end

local function StopAutoOpen()
    AutoOpen = false
end

-- 🟢 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HuntyZombieUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0.5, -110, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚡ HuntyZombie v3 Fast"
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
openBtn.Text = "AutoOpen Door: OFF"
openBtn.Font = Enum.Font.Gotham
openBtn.TextSize = 14
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.Parent = frame
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

openBtn.MouseButton1Click:Connect(function()
    AutoOpen = not AutoOpen
    openBtn.Text = AutoOpen and "AutoOpen Door: ON" or "AutoOpen Door: OFF"
    openBtn.BackgroundColor3 = AutoOpen and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
    if AutoOpen then StartAutoOpen() else StopAutoOpen() end
end)

-- Tombol Hide/Show
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
    if hidden then
        local showBtn = Instance.new("TextButton")
        showBtn.Size = UDim2.new(0, 80, 0, 30)
        showBtn.Position = UDim2.new(0, 20, 0.8, 0)
        showBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        showBtn.Text = "Show GUI"
        showBtn.TextColor3 = Color3.new(1, 1, 1)
        showBtn.Font = Enum.Font.Gotham
        showBtn.TextSize = 14
        showBtn.Draggable = true
        showBtn.Parent = gui
        Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 8)
        showBtn.MouseButton1Click:Connect(function()
            frame.Visible = true
            hidden = false
            showBtn:Destroy()
        end)
    end
end)
