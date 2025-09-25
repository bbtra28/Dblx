-- Save & Teleport Multi Slot (1-10) + Clear + Hide/Show + Marker Sphere + Nomor Angka
-- GUI ukuran kecil + tanda bayangan berbentuk bola + angka slot di atas marker

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Global biar tetap ada walau respawn
getgenv().savedPositions = getgenv().savedPositions or {}
getgenv().savedMarkers = getgenv().savedMarkers or {}

-- GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SaveTP_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 360)
MainFrame.Position = UDim2.new(0, 20, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "Save & Teleport (1-10)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Parent = MainFrame

-- Tombol Hide
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 80, 0, 25)
HideButton.Position = UDim2.new(1, -85, 0, 0)
HideButton.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
HideButton.Text = "Hide"
HideButton.TextColor3 = Color3.new(1, 1, 1)
HideButton.TextScaled = true
HideButton.Parent = MainFrame

-- Tombol Show
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 70, 0, 25)
ShowButton.Position = UDim2.new(0, 20, 0, 100)
ShowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ShowButton.Text = "Show"
ShowButton.TextColor3 = Color3.new(1, 1, 1)
ShowButton.TextScaled = true
ShowButton.Visible = false
ShowButton.Active = true
ShowButton.Draggable = true
ShowButton.Parent = ScreenGui

-- Fungsi ambil root
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

-- Buat marker sphere
local function createMarker(cf, slot)
    -- Hapus marker lama
    if getgenv().savedMarkers[slot] then
        getgenv().savedMarkers[slot]:Destroy()
        getgenv().savedMarkers[slot] = nil
    end

    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(2, 2, 2)
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.CFrame = cf
    sphere.Color = Color3.fromRGB(0, 255, 100)
    sphere.Transparency = 0.4
    sphere.Name = "SavedMarker_" .. slot
    sphere.Parent = Workspace

    -- Billboard angka slot
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = sphere
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = sphere

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = tostring(slot) -- hanya angka
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Parent = billboard

    getgenv().savedMarkers[slot] = sphere
end

-- Fungsi buat tombol
local function createButton(text, posX, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 25)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Tombol Save / TP / Clear
for i = 1, 10 do
    local yPos = 30 + ((i - 1) * 30)

    createButton("S" .. i, 10, yPos, Color3.fromRGB(50, 200, 50), function()
        local root = getRoot()
        local cf = root.CFrame
        getgenv().savedPositions[i] = cf
        createMarker(cf, i)
    end)

    createButton("TP" .. i, 90, yPos, Color3.fromRGB(50, 50, 200), function()
        local root = getRoot()
        if getgenv().savedPositions[i] then
            root.CFrame = getgenv().savedPositions[i]
        end
    end)

    createButton("C" .. i, 170, yPos, Color3.fromRGB(200, 50, 50), function()
        getgenv().savedPositions[i] = nil
        if getgenv().savedMarkers[i] then
            getgenv().savedMarkers[i]:Destroy()
            getgenv().savedMarkers[i] = nil
        end
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
