-- Low Graphics Toggle GUI (Executor Friendly + X / – Show-Hide) -- Cara pakai: paste ke executor dan jalankan. -- Fitur: toggle low-graphics on/off, GUI draggable, show FPS & ping, show/hide GUI dengan tombol X dan –

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Lighting = game:GetService("Lighting") local Stats = game:GetService("Stats") local UserInputService = game:GetService("UserInputService")

-- Simpan pengaturan asli supaya bisa dikembalikan local original = { QualityLevel = (pcall(function() return settings().Rendering.QualityLevel end) and settings().Rendering.QualityLevel) or 10, GlobalShadows = Lighting.GlobalShadows, Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd, }

local lowGraphicsEnabled = false

-- Membuat GUI local screenGui = Instance.new("ScreenGui") screenGui.Name = "LowGraphicsGUI" screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame") mainFrame.Name = "Main" mainFrame.Size = UDim2.new(0, 220, 0, 120) mainFrame.Position = UDim2.new(0, 20, 0, 80) mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) mainFrame.BorderSizePixel = 0 mainFrame.Parent = screenGui

local title = Instance.new("TextLabel") title.Size = UDim2.new(1, -60, 0, 28) title.BackgroundTransparency = 1 title.Text = "Low Graphics" title.Font = Enum.Font.SourceSansBold title.TextSize = 18 title.TextColor3 = Color3.fromRGB(255,255,255) title.TextXAlignment = Enum.TextXAlignment.Left title.Parent = mainFrame

-- Tombol minimize (–) local minimizeBtn = Instance.new("TextButton") minimizeBtn.Size = UDim2.new(0, 28, 0, 24) minimizeBtn.Position = UDim2.new(1, -60, 0, 2) minimizeBtn.Text = "–" minimizeBtn.Font = Enum.Font.SourceSansBold minimizeBtn.TextSize = 18 minimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60) minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255) minimizeBtn.BorderSizePixel = 0 minimizeBtn.Parent = mainFrame

-- Tombol close (X) local closeBtn = Instance.new("TextButton") closeBtn.Size = UDim2.new(0, 28, 0, 24) closeBtn.Position = UDim2.new(1, -30, 0, 2) closeBtn.Text = "X" closeBtn.Font = Enum.Font.SourceSansBold closeBtn.TextSize = 18 closeBtn.BackgroundColor3 = Color3.fromRGB(120,40,40) closeBtn.TextColor3 = Color3.fromRGB(255,255,255) closeBtn.BorderSizePixel = 0 closeBtn.Parent = mainFrame

local toggleBtn = Instance.new("TextButton") toggleBtn.Size = UDim2.new(0, -20, 0, 34) toggleBtn.Position = UDim2.new(0, 10, 0, 34) toggleBtn.Text = "Turn Low ON" toggleBtn.Font = Enum.Font.SourceSans toggleBtn.TextSize = 16 toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) toggleBtn.TextColor3 = Color3.fromRGB(255,255,255) toggleBtn.BorderSizePixel = 0 toggleBtn.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel") fpsLabel.Size = UDim2.new(1, -20, 0, 20) fpsLabel.Position = UDim2.new(0, 10, 0, 74) fpsLabel.BackgroundTransparency = 1 fpsLabel.Text = "FPS: --  |  PING: -- ms" fpsLabel.Font = Enum.Font.SourceSans fpsLabel.TextSize = 14 fpsLabel.TextColor3 = Color3.fromRGB(220,220,220) fpsLabel.TextXAlignment = Enum.TextXAlignment.Left fpsLabel.Parent = mainFrame

-- Dragging logic local dragging, dragInput, dragStart, startPos

local function update(input) local delta = input.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end

title.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Show/Hide logic local hidden = false local function setHidden(h) hidden = h if hidden then for _, child in ipairs(mainFrame:GetChildren()) do if child ~= minimizeBtn and child ~= closeBtn and child ~= title then child.Visible = false end end mainFrame.Size = UDim2.new(0, 220, 0, 28) else for _, child in ipairs(mainFrame:GetChildren()) do child.Visible = true end mainFrame.Size = UDim2.new(0, 220, 0, 120) end end

minimizeBtn.MouseButton1Click:Connect(function() setHidden(not hidden) end)

closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Low graphics toggle local prevValues = {}

local function enableLowGraphics() if lowGraphicsEnabled then return end lowGraphicsEnabled = true

pcall(function() prevValues.QualityLevel = settings().Rendering.QualityLevel end)
prevValues.GlobalShadows = Lighting.GlobalShadows
prevValues.Brightness = Lighting.Brightness
prevValues.FogEnd = Lighting.FogEnd

pcall(function() settings().Rendering.QualityLevel = 1 end)
Lighting.GlobalShadows = false
Lighting.Brightness = math.clamp(Lighting.Brightness * 0.9, 0, 10)
Lighting.FogEnd = 1000

task.spawn(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function() obj.Material = Enum.Material.Plastic end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 1 end)
        end
    end
end)

end

local function disableLowGraphics() if not lowGraphicsEnabled then return end lowGraphicsEnabled = false

pcall(function()
    if prevValues.QualityLevel then
        settings().Rendering.QualityLevel = prevValues.QualityLevel
    end
end)
if prevValues.GlobalShadows ~= nil then Lighting.GlobalShadows = prevValues.GlobalShadows end
if prevValues.Brightness ~= nil then Lighting.Brightness = prevValues.Brightness end
if prevValues.FogEnd ~= nil then Lighting.FogEnd = prevValues.FogEnd end

task.spawn(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 0 end)
        end
    end
end)

end

toggleBtn.MouseButton1Click:Connect(function() if lowGraphicsEnabled then disableLowGraphics() toggleBtn.Text = "Turn Low ON" else enableLowGraphics() toggleBtn.Text = "Turn Low OFF" end end)

-- FPS & Ping updater local fps, frameCount, accumulator = 0, 0, 0 RunService.RenderStepped:Connect(function(dt) frameCount += 1 accumulator += dt if accumulator >= 0.5 then fps = math.floor(frameCount / accumulator + 0.5) frameCount, accumulator = 0, 0

local ping = "--"
    pcall(function()
        local item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
        if item then
            ping = math.floor(item:GetValue() + 0.5)
        end
    end)

    fpsLabel.Text = string.format("FPS: %s  |  PING: %s ms", tostring(fps), tostring(ping))
end

end)

-- Parent GUI ke CoreGui (agar muncul di executor) screenGui.Parent = game:GetService("CoreGui")

print("Low Graphics GUI (Executor) with X and – buttons loaded")

