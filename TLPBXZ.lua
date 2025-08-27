-- LocalScript
local player = game.Players.LocalPlayer
local teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "TeleportGui"
teleportGui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
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

-- Dropdown (pakai TextBox + list player)
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -20, 0, 40)
dropdown.Position = UDim2.new(0, 10, 0, 50)
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.Text = "Select Player"
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.SourceSans
dropdown.TextSize = 18
dropdown.Parent = mainFrame

-- List Frame buat dropdown pilihan
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(1, -20, 0, 100)
listFrame.Position = UDim2.new(0, 10, 0, 95)
listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listFrame.Visible = false
listFrame.Parent = mainFrame

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, -5, 1, -5)
listScroll.Position = UDim2.new(0, 2, 0, 2)
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
listScroll.ScrollBarThickness = 6
listScroll.BackgroundTransparency = 1
listScroll.Parent = listFrame

local uiList = Instance.new("UIListLayout")
uiList.Parent = listScroll
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 3)

-- Tombol teleport
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 40)
teleportButton.Position = UDim2.new(0, 10, 1, -50)
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 20
teleportButton.Parent = mainFrame

-- Simpan pilihan
local selectedPlayer = nil

-- Fungsi buat isi dropdown
local function refreshDropdown()
    for _, child in pairs(listScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local option = Instance.new("TextButton")
            option.Size = UDim2.new(1, -5, 0, 25)
            option.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            option.Text = plr.Name
            option.TextColor3 = Color3.fromRGB(255, 255, 255)
            option.Font = Enum.Font.SourceSans
            option.TextSize = 16
            option.Parent = listScroll

            option.MouseButton1Click:Connect(function()
                dropdown.Text = plr.Name
                selectedPlayer = plr
                listFrame.Visible = false
            end)
        end
    end
end

-- Dropdown toggle
dropdown.MouseButton1Click:Connect(function()
    if listFrame.Visible then
        listFrame.Visible = false
    else
        refreshDropdown()
        listFrame.Visible = true
    end
end)

-- Tombol teleport
teleportButton.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
end)

-- Update kalau ada player baru / keluar
game.Players.PlayerAdded:Connect(refreshDropdown)
game.Players.PlayerRemoving:Connect(refreshDropdown)

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

-- Pertama kali isi
refreshDropdown()