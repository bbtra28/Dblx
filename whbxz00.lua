local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Buat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "WallhackGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Buat Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Tombol Wallhack
local wallhackButton = Instance.new("TextButton")
wallhackButton.Size = UDim2.new(1, -20, 0, 40)
wallhackButton.Position = UDim2.new(0, 10, 0, 20)
wallhackButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
wallhackButton.TextColor3 = Color3.new(1, 1, 1)
wallhackButton.Text = "Enable Wallhack"
wallhackButton.Font = Enum.Font.SourceSansBold
wallhackButton.TextSize = 18
wallhackButton.Parent = frame

-- Tombol Merah
local redButton = Instance.new("TextButton")
redButton.Size = UDim2.new(0.45, 0, 0, 30)
redButton.Position = UDim2.new(0.05, 0, 0, 70)
redButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
redButton.TextColor3 = Color3.new(1, 1, 1)
redButton.Text = "Merah"
redButton.Font = Enum.Font.SourceSansBold
redButton.TextSize = 16
redButton.Parent = frame

-- Tombol Hijau
local greenButton = Instance.new("TextButton")
greenButton.Size = UDim2.new(0.45, 0, 0, 30)
greenButton.Position = UDim2.new(0.5, 0, 0, 70)
greenButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
greenButton.TextColor3 = Color3.new(1, 1, 1)
greenButton.Text = "Hijau"
greenButton.Font = Enum.Font.SourceSansBold
greenButton.TextSize = 16
greenButton.Parent = frame

-- Variabel Toggle
local wallhackEnabled = false
local currentColor = Color3.fromRGB(0, 255, 0) -- default hijau

-- Fungsi username tag
local function addNameTag(player)
    if player == LocalPlayer then return end
    if player.Character and player.Character:FindFirstChild("Head") then
        if not player.Character.Head:FindFirstChild("NameTag") then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Size = UDim2.new(0, 100, 0, 20)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0) -- posisi di atas kepala
            billboard.AlwaysOnTop = true
            billboard.Parent = player.Character.Head

            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, 0, 1, 0)
            text.BackgroundTransparency = 1
            text.Text = player.Name
            text.TextColor3 = Color3.new(1, 1, 1)
            text.Font = Enum.Font.SourceSansBold
            text.TextSize = 14
            text.Parent = billboard
        end
    end
end

-- Fungsi highlight
local function setWallhack(player, enabled)
    if player == LocalPlayer then return end
    if player.Character then
        local existing = player.Character:FindFirstChild("WallhackHighlight")
        if enabled then
            if not existing then
                local highlight = Instance.new("Highlight")
                highlight.Name = "WallhackHighlight"
                highlight.FillColor = currentColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = player.Character
            else
                existing.FillColor = currentColor
            end
            addNameTag(player) -- tambahin username kalau aktif
        else
            if existing then
                existing:Destroy()
            end
            if player.Character and player.Character:FindFirstChild("Head") then
                local tag = player.Character.Head:FindFirstChild("NameTag")
                if tag then tag:Destroy() end
            end
        end
    end
end

-- Update semua pemain
local function toggleWallhack(enabled)
    for _, p in ipairs(Players:GetPlayers()) do
        setWallhack(p, enabled)
    end
end

-- Update saat ada player baru
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if wallhackEnabled then
            setWallhack(player, true)
        end
    end)
end)

-- Tombol utama
wallhackButton.MouseButton1Click:Connect(function()
    wallhackEnabled = not wallhackEnabled
    toggleWallhack(wallhackEnabled)
    wallhackButton.Text = wallhackEnabled and "Disable Wallhack" or "Enable Wallhack"
    wallhackButton.BackgroundColor3 = wallhackEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 120, 255)
end)

-- Tombol merah
redButton.MouseButton1Click:Connect(function()
    currentColor = Color3.fromRGB(255, 0, 0)
    if wallhackEnabled then
        toggleWallhack(true)
    end
end)

-- Tombol hijau
greenButton.MouseButton1Click:Connect(function()
    currentColor = Color3.fromRGB(0, 255, 0)
    if wallhackEnabled then
        toggleWallhack(true)
    end
end)
