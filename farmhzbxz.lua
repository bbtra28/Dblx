-- Fly GUI V3 (Versi Asli) + Noclip & Low GFX

-- Instances
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")
local noclipBtn = Instance.new("TextButton")
local gfxBtn = Instance.new("TextButton")

-- Properties GUI
main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 150)
Frame.Active = true
Frame.Draggable = true

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Position = UDim2.new(0, 0, 0, 0)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Fly GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = Enum.Font.SourceSans
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position = UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = Enum.Font.SourceSans
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = Enum.Font.SourceSans
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

-- Tombol tambahan
noclipBtn.Name = "noclipBtn"
noclipBtn.Parent = Frame
noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
noclipBtn.Position = UDim2.new(0.5, 0, 1.05, 0)
noclipBtn.Size = UDim2.new(0, 80, 0, 28)
noclipBtn.Font = Enum.Font.SourceSans
noclipBtn.Text = "Noclip: OFF"
noclipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
noclipBtn.TextSize = 14.000

gfxBtn.Name = "gfxBtn"
gfxBtn.Parent = Frame
gfxBtn.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
gfxBtn.Position = UDim2.new(0.01, 0, 1.05, 0)
gfxBtn.Size = UDim2.new(0, 90, 0, 28)
gfxBtn.Font = Enum.Font.SourceSans
gfxBtn.Text = "Low GFX: OFF"
gfxBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
gfxBtn.TextSize = 14.000

-- Variables
local RunService = game:GetService("RunService")
local noclipEnabled = false
local gfxEnabled = false
local tpwalking = false
local speaker = game:GetService("Players").LocalPlayer
local speeds = 1

-- Fly Logic (versi lama TranslateBy)
onof.MouseButton1Click:Connect(function()
    if tpwalking then
        tpwalking = false
        onof.Text = "fly"
    else
        tpwalking = true
        onof.Text = "stop"
        local hb = RunService.Heartbeat
        while tpwalking and hb:Wait() and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") do
            local hum = speaker.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.Parent:TranslateBy(hum.MoveDirection * speeds)
            end
        end
    end
end)

-- UP / DOWN control
up.MouseButton1Click:Connect(function()
    if speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") then
        speaker.Character:FindFirstChild("HumanoidRootPart").CFrame = speaker.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, 5, 0)
    end
end)

down.MouseButton1Click:Connect(function()
    if speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") then
        speaker.Character:FindFirstChild("HumanoidRootPart").CFrame = speaker.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, -5, 0)
    end
end)

-- Speed control
plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speed.Text = tostring(speeds)
end)

mine.MouseButton1Click:Connect(function()
    speeds = math.max(1, speeds - 1)
    speed.Text = tostring(speeds)
end)

-- Close & Minimize
closebutton.MouseButton1Click:Connect(function()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    Frame.Visible = false
    mini2.Visible = true
end)

mini2.MouseButton1Click:Connect(function()
    Frame.Visible = true
    mini2.Visible = false
end)

-- Toggle Noclip
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        RunService.Stepped:Connect(function()
            if noclipEnabled and speaker.Character then
                for _, v in pairs(speaker.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 150)
    end
end)

-- Toggle Low GFX
gfxBtn.MouseButton1Click:Connect(function()
    gfxEnabled = not gfxEnabled
    if gfxEnabled then
        gfxBtn.Text = "Low GFX: ON"
        gfxBtn.BackgroundColor3 = Color3.fromRGB(200, 255, 200)
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("Explosion") then
                v.Visible = false
            end
        end
    else
        gfxBtn.Text = "Low GFX: OFF"
        gfxBtn.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    end
end)
