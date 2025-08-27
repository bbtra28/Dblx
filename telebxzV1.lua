local player = game.Players.LocalPlayer
local teleportGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local closeButton = Instance.new("TextButton")
local refreshButton = Instance.new("TextButton")
local playerListFrame = Instance.new("ScrollingFrame")
local layout = Instance.new("UIListLayout")

-- Gui setup
teleportGui.Name = "TeleportGui"
teleportGui.Parent = player:WaitForChild("PlayerGui")

mainFrame.Name = "MainFrame"
mainFrame.Parent = teleportGui
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Active = true

titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Teleport GUI - KrakenOfficialBG/Yt"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 20

closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)

refreshButton.Parent = mainFrame
refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
refreshButton.Position = UDim2.new(0, 10, 0, 185)
refreshButton.Size = UDim2.new(0, 280, 0, 25)
refreshButton.Font = Enum.Font.SourceSansBold
refreshButton.Text = "Refresh Player List"
refreshButton.TextColor3 = Color3.new(1, 1, 1)
refreshButton.TextSize = 16

playerListFrame.Parent = mainFrame
playerListFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
playerListFrame.Position = UDim2.new(0, 10, 0, 40)
playerListFrame.Size = UDim2.new(0, 280, 0, 140)
playerListFrame.ScrollBarThickness = 6

-- Layout biar rapi otomatis
layout.Parent = playerListFrame
layout.Padding = UDim.new(0, 5)

-- Fungsi buat tombol player
local function createPlayerButton(p)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    btn.Text = p.Name
    btn.Parent = playerListFrame

    btn.MouseButton1Click:Connect(function()
        local char = player.Character
        local targetChar = p.Character
        if char and targetChar then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
            if hrp and targetHrp then
                hrp.CFrame = targetHrp.CFrame + Vector3.new(2, 0, 0)
            end
        end
    end)
end

-- Fungsi buat update list pemain
local function refreshPlayerList()
    for _, child in ipairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            createPlayerButton(plr)
        end
    end
end

-- Refresh pertama kali
refreshPlayerList()

-- Auto update kalau ada player join
game.Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)

-- Auto update kalau ada player keluar
game.Players.PlayerRemoving:Connect(function()
    refreshPlayerList()
end)

-- Tombol refresh manual
refreshButton.MouseButton1Click:Connect(function()
    refreshPlayerList()
end)

-- Close button
closeButton.MouseButton1Click:Connect(function()
    teleportGui:Destroy()
end)

-- Custom drag
local UIS = game:GetService("UserInputService")
local dragging, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < (titleLabel.AbsolutePosition.Y + titleLabel.AbsoluteSize.Y) then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)