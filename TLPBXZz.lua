-- LocalScript
local player = game.Players.LocalPlayer
local teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "TeleportGui"
teleportGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = teleportGui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
title.Text = "Teleport Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = mainFrame

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Parent = mainFrame

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -80, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.Parent = mainFrame

-- Tombol Reopen (awal hidden)
local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 120, 0, 40)
reopenButton.Position = UDim2.new(0, 10, 1, -50)
reopenButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
reopenButton.Text = "Open Teleport"
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Font = Enum.Font.SourceSansBold
reopenButton.TextSize = 18
reopenButton.Visible = false
reopenButton.Parent = teleportGui

-- ScrollFrame daftar player
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -10, 1, -50)
playerList.Position = UDim2.new(0, 5, 0, 45)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0) -- akan auto update
playerList.ScrollBarThickness = 6
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = playerList
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

-- Fungsi update CanvasSize sesuai jumlah tombol
local function updateCanvas()
    playerList.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end
uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- Fungsi buat tombol player
local function createButton(targetPlayer)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = targetPlayer.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Parent = playerList

    btn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end
    end)

    updateCanvas()
end

-- Tambahin semua player yang ada
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= player then
        createButton(plr)
    end
end

-- Kalau ada player baru join
game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        createButton(plr)
    end
end)

-- Kalau player keluar, hapus tombolnya
game.Players.PlayerRemoving:Connect(function(plr)
    for _, btn in pairs(playerList:GetChildren()) do
        if btn:IsA("TextButton") and btn.Text == plr.Name then
            btn:Destroy()
            updateCanvas()
        end
    end
end)

-- Event Close
closeButton.MouseButton1Click:Connect(function()
    teleportGui:Destroy()
end)

-- Event Minimize
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenButton.Visible = true
end)

-- Event Reopen
reopenButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenButton.Visible = false
end)