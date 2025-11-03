-- 🌐 Auto Teleport ke Part bernama "root" + GUI On/Off
-- 💻 Kompatibel: Arceus X, Delta, Fluxus, Hydrogen, VegaX
-- 📱 Support HP & PC

-- Buat GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Toggle = Instance.new("TextButton")

ScreenGui.Name = "RootTeleportGUI"
ScreenGui.Parent = game.CoreGui

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Size = UDim2.new(0, 180, 0, 80)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.Active = true
Frame.Draggable = true

Title.Parent = Frame
Title.Text = "Auto Root Teleport"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

Toggle.Parent = Frame
Toggle.Text = "ON"
Toggle.Size = UDim2.new(1, 0, 0, 40)
Toggle.Position = UDim2.new(0, 0, 0.45, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 20

-- Variabel
local enabled = false
local teleportDelay = 1.5 -- jeda antar teleport (detik)

-- Fungsi cari semua part bernama "root"
local function getAllRoots()
    local roots = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "root" then
            table.insert(roots, v)
        end
    end
    return roots
end

-- Fungsi auto teleport ke root berikutnya
task.spawn(function()
    while task.wait(teleportDelay) do
        if enabled then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local roots = getAllRoots()
                table.sort(roots, function(a, b)
                    return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                end)
                for _, root in pairs(roots) do
                    if enabled then
                        hrp.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                        task.wait(teleportDelay)
                    else
                        break
                    end
                end
            end
        end
    end
end)

-- Tombol on/off
Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        Toggle.Text = "OFF"
        Toggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    else
        Toggle.Text = "ON"
        Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)
