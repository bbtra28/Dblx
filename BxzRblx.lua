-- Save & Teleport Multi Slot (1-10) + Clear + Hide/Show + Persist After Respawn
-- Data save pakai getgenv() biar tetap ada saat respawn

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Gunakan global environment agar slot tidak hilang saat respawn
getgenv().savedPositions = getgenv().savedPositions or {}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SaveTP_GUI"
ScreenGui.ResetOnSpawn = false -- supaya GUI tidak hilang saat respawn
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Save & Teleport (1-10)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

-- Tombol Hide
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 100, 0, 30)
HideButton.Position = UDim2.new(1, -110, 0, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.Parent = MainFrame

-- Tombol Show
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 80, 0, 30)
ShowButton.Position = UDim2.new(0, 20, 0, 100)
ShowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ShowButton.Text = "Show"
ShowButton.TextColor3 = Color3.new(1, 1, 1)
ShowButton.Visible = false
ShowButton.Active = true
ShowButton.Draggable = true
ShowButton.Parent = ScreenGui

-- Fungsi ambil root aman
local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    while not root do
        task.wait()
        char = player.Character or player.CharacterAdded:Wait()
        root = char:FindFirstChild("HumanoidRootPart")
    end
    return root
end

-- Fungsi buat tombol
local function createButton(text, posX, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Buat tombol Save / TP / Clear
for i = 1, 10 do
    local yPos = 40 + ((i - 1) * 40)

    createButton("Save " .. i, 10, yPos, Color3.fromRGB(50, 200, 50), function()
        local root = getRoot()
        getgenv().savedPositions[i] = root.CFrame
        warn("Saved slot " .. i)
    end)

    createButton("TP " .. i, 120, yPos, Color3.fromRGB(50, 50, 200), function()
        local root = getRoot()
        if getgenv().savedPositions[i] then
            root.CFrame = getgenv().savedPositions[i]
            warn("Teleported to slot " .. i)
        end
    end)

    createButton("Clear " .. i, 230, yPos, Color3.fromRGB(200, 50, 50), function()
        getgenv().savedPositions[i] = nil
        warn("Cleared slot " .. i)
    end)
end

-- Logic Hide / Show
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)
