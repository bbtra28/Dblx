-- 🌀 Auto Teleport ke Part "root" + GUI On/Off
-- ✅ Kompatibel: Arceus X, Delta, Fluxus, Hydrogen, VegaX
-- 📱 Support HP & PC

-- GUI
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local toggle = Instance.new("TextButton")

gui.Name = "RootTeleportGUI"
gui.Parent = game:GetService("CoreGui")

frame.Name = "MainFrame"
frame.Parent = gui
frame.Size = UDim2.new(0, 180, 0, 80)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true

title.Parent = frame
title.Text = "Auto Root Teleport"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

toggle.Parent = frame
toggle.Text = "ON"
toggle.Size = UDim2.new(1, 0, 0, 40)
toggle.Position = UDim2.new(0, 0, 0.45, 0)
toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 20

-- Variabel utama
local enabled = false
local teleportDelay = 1.5

-- Fungsi ambil semua part bernama "root"
local function getAllRoots()
    local roots = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "root" then
            table.insert(roots, v)
        end
    end
    return roots
end

-- Fungsi teleport ke part
local function teleportTo(part)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

-- Loop teleport
task.spawn(function()
    while task.wait(teleportDelay) do
        if enabled then
            local roots = getAllRoots()
            local player = game.Players.LocalPlayer
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if #roots > 0 and hrp then
                -- urutkan berdasarkan jarak
                table.sort(roots, function(a, b)
                    return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                end)

                for _, root in ipairs(roots) do
                    if not enabled then break end
                    teleportTo(root)
                    task.wait(teleportDelay)
                end
            end
        end
    end
end)

-- Tombol ON/OFF
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    else
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)
