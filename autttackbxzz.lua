-- 🟢 Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- 🟢 Variabel status
local AutoFarm = false
local AutoOpen = false

-- 🟢 Fungsi AutoFarm
function StartAutoFarm()
    AutoFarm = true
    task.spawn(function()
        while AutoFarm do
            task.wait(0.5)
            for _, mob in pairs(Workspace:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        VirtualUser:ClickButton1(Vector2.new())
                    end
                end
            end
        end
    end)
end

function StopAutoFarm()
    AutoFarm = false
end

-- 🟢 Fungsi AutoOpen
function StartAutoOpen()
    AutoOpen = true
    task.spawn(function()
        while AutoOpen do
            task.wait(1)
            for _, door in pairs(Workspace:GetDescendants()) do
                if door:IsA("ProximityPrompt") then
                    fireproximityprompt(door)
                end
            end
        end
    end)
end

function StopAutoOpen()
    AutoOpen = false
end

-- 🟢 GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 🟢 Frame utama
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 150)
Frame.Position = UDim2.new(0.5, -110, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- 🟢 Ujung bulat & bayangan
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- 🟢 Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "🧟 HuntyZombie GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Frame

-- 🟢 Tombol AutoFarm
local BtnAutoFarm = Instance.new("TextButton")
BtnAutoFarm.Size = UDim2.new(1, -20, 0, 35)
BtnAutoFarm.Position = UDim2.new(0, 10, 0, 40)
BtnAutoFarm.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnAutoFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAutoFarm.Text = "AutoFarm: OFF"
BtnAutoFarm.Font = Enum.Font.Gotham
BtnAutoFarm.TextSize = 14
BtnAutoFarm.Parent = Frame

local BtnFarmCorner = Instance.new("UICorner", BtnAutoFarm)
BtnFarmCorner.CornerRadius = UDim.new(0, 8)

BtnAutoFarm.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    BtnAutoFarm.Text = AutoFarm and "AutoFarm: ON" or "AutoFarm: OFF"
    BtnAutoFarm.BackgroundColor3 = AutoFarm and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
    if AutoFarm then StartAutoFarm() else StopAutoFarm() end
end)

-- 🟢 Tombol AutoOpen
local BtnAutoOpen = Instance.new("TextButton")
BtnAutoOpen.Size = UDim2.new(1, -20, 0, 35)
BtnAutoOpen.Position = UDim2.new(0, 10, 0, 85)
BtnAutoOpen.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnAutoOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAutoOpen.Text = "AutoOpen Door: OFF"
BtnAutoOpen.Font = Enum.Font.Gotham
BtnAutoOpen.TextSize = 14
BtnAutoOpen.Parent = Frame

local BtnOpenCorner = Instance.new("UICorner", BtnAutoOpen)
BtnOpenCorner.CornerRadius = UDim.new(0, 8)

BtnAutoOpen.MouseButton1Click:Connect(function()
    AutoOpen = not AutoOpen
    BtnAutoOpen.Text = AutoOpen and "AutoOpen Door: ON" or "AutoOpen Door: OFF"
    BtnAutoOpen.BackgroundColor3 = AutoOpen and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 40)
    if AutoOpen then StartAutoOpen() else StopAutoOpen() end
end)

-- 🟢 Tombol Hide / Show
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Position = UDim2.new(0.5, -40, 1, 10)
ToggleButton.Text = "Hide"
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 14
ToggleButton.Parent = Frame

local BtnCorner = Instance.new("UICorner", ToggleButton)
BtnCorner.CornerRadius = UDim.new(0, 8)

local Hidden = false
ToggleButton.MouseButton1Click:Connect(function()
    Hidden = not Hidden
    Frame.Visible = not Hidden
    if Hidden then
        local ShowButton = Instance.new("TextButton")
        ShowButton.Name = "ShowButton"
        ShowButton.Size = UDim2.new(0, 80, 0, 30)
        ShowButton.Position = UDim2.new(0, 20, 0.8, 0)
        ShowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ShowButton.Text = "Show GUI"
        ShowButton.Font = Enum.Font.Gotham
        ShowButton.TextSize = 14
        ShowButton.Active = true
        ShowButton.Draggable = true
        ShowButton.Parent = ScreenGui

        local corner = Instance.new("UICorner", ShowButton)
        corner.CornerRadius = UDim.new(0, 8)

        ShowButton.MouseButton1Click:Connect(function()
            Frame.Visible = true
            Hidden = false
            ShowButton:Destroy()
        end)
    end
end)
