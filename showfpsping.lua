-- Show FPS & Ping HUD (executor version) 
-- Bisa digeser

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "PerfHUD"
gui.Parent = game.CoreGui -- executor: langsung ke CoreGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 60)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- executor biasanya bisa pakai langsung
frame.Parent = gui

-- Judul
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.BackgroundTransparency = 0.3
title.Text = "Perf HUD"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- FPS label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 0, 18)
fpsLabel.Position = UDim2.new(0, 5, 0, 22)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Text = "FPS: ..."
fpsLabel.Parent = frame

-- Ping label
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, -10, 0, 18)
pingLabel.Position = UDim2.new(0, 5, 0, 40)
pingLabel.BackgroundTransparency = 1
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Font = Enum.Font.SourceSans
pingLabel.TextSize = 14
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.Text = "Ping: ..."
pingLabel.Parent = frame

-- FPS counter
local last = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(frames)
        frames = 0
        last = tick()
    end
end)

-- Ping updater
task.spawn(function()
    while task.wait(0.5) do
        local ok, ping = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and typeof(ping) == "number" then
            pingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
        elseif player and player.GetNetworkPing then
            pingLabel.Text = "Ping: " .. math.floor(player:GetNetworkPing() * 1000) .. " ms"
        else
            pingLabel.Text = "Ping: N/A"
        end
    end
end)