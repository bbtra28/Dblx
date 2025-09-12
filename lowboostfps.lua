-- Low Graphics Toggle GUI (LocalScript) -- Cara pakai: taruh sebagai LocalScript di StarterPlayerScripts atau jalankan lewat executor yang mendukung LocalScript. -- Fitur: toggle low-graphics on/off, GUI draggable, show FPS & ping, show/hide GUI

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Lighting = game:GetService("Lighting") local Stats = game:GetService("Stats") local LocalPlayer = Players.LocalPlayer local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Simpan pengaturan asli supaya bisa dikembalikan local original = { QualityLevel = (pcall(function() return settings().Rendering.QualityLevel end) and settings().Rendering.QualityLevel) or 10, GlobalShadows = Lighting.GlobalShadows, Brightness = Lighting.Brightness, FogEnd = Lighting.FogEnd, TerrainQuality = nil, }

local lowGraphicsEnabled = false

-- Membuat GUI local screenGui = Instance.new("ScreenGui") screenGui.Name = "LowGraphicsGUI" screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame") mainFrame.Name = "Main" mainFrame.Size = UDim2.new(0, 220, 0, 120) mainFrame.Position = UDim2.new(0, 20, 0, 80) mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) mainFrame.BorderSizePixel = 0 mainFrame.Parent = screenGui

local title = Instance.new("TextLabel") title.Name = "Title" title.Size = UDim2.new(1, 0, 0, 28) title.BackgroundTransparency = 1 title.Position = UDim2.new(0, 0, 0, 0) title.Text = "Low Graphics" title.Font = Enum.Font.SourceSansBold title.TextSize = 18 title.TextColor3 = Color3.fromRGB(255,255,255) title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton") toggleBtn.Name = "Toggle" toggleBtn.Size = UDim2.new(0, -20, 0, 34) toggleBtn.Position = UDim2.new(0, 10, 0, 34) toggleBtn.Text = "Turn Low ON" toggleBtn.Font = Enum.Font.SourceSans toggleBtn.TextSize = 16 toggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50) toggleBtn.TextColor3 = Color3.fromRGB(255,255,255) toggleBtn.BorderSizePixel = 0 toggleBtn.Parent = mainFrame

local hideBtn = Instance.new("TextButton") hideBtn.Name = "Hide" hideBtn.Size = UDim2.new(0, 32, 0, 24) hideBtn.Position = UDim2.new(1, -40, 0, 6) hideBtn.Text = "–" hideBtn.Font = Enum.Font.SourceSansBold hideBtn.TextSize = 18 hideBtn.BackgroundTransparency = 0.2 hideBtn.TextColor3 = Color3.fromRGB(255,255,255) hideBtn.BorderSizePixel = 0 hideBtn.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel") fpsLabel.Name = "FPS" fpsLabel.Size = UDim2.new(1, -20, 0, 20) fpsLabel.Position = UDim2.new(0, 10, 0, 74) fpsLabel.BackgroundTransparency = 1 fpsLabel.Text = "FPS: --  |  PING: -- ms" fpsLabel.Font = Enum.Font.SourceSans fpsLabel.TextSize = 14 fpsLabel.TextColor3 = Color3.fromRGB(220,220,220) fpsLabel.TextXAlignment = Enum.TextXAlignment.Left fpsLabel.Parent = mainFrame

-- Dragging logic local dragging, dragInput, dragStart, startPos

local function update(input) local delta = input.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end

title.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = mainFrame.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)

title.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)

UserInputService = game:GetService("UserInputService") UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)

-- Show/Hide logic local hidden = false local function setHidden(h) hidden = h if hidden then mainFrame.Visible = false hideBtn.Text = "+" else mainFrame.Visible = true hideBtn.Text = "–" end end

hideBtn.MouseButton1Click:Connect(function() setHidden(not hidden) end)

-- Low graphics toggle implementation (best-effort) local prevValues = {}

local function enableLowGraphics() if lowGraphicsEnabled then return end lowGraphicsEnabled = true

-- simpan nilai sebelumnya
pcall(function()
    prevValues.QualityLevel = settings().Rendering.QualityLevel
end)
prevValues.GlobalShadows = Lighting.GlobalShadows
prevValues.Brightness = Lighting.Brightness
prevValues.FogEnd = Lighting.FogEnd

-- terapkan low settings
pcall(function()
    settings().Rendering.QualityLevel = 1 -- paling rendah
end)
Lighting.GlobalShadows = false
Lighting.Brightness = math.clamp(Lighting.Brightness * 0.9, 0, 10)
Lighting.FogEnd = 1000

-- disable textures & decals (best-effort, non-invasive)
-- ubah material sebagian besar parts ke Plastic (cukup cepat) -- lakukan dengan hati-hati
task.spawn(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            pcall(function()
                obj.Material = Enum.Material.Plastic
                -- jangan ubah properties yang bisa merusak gameplay (contoh: Anchored)
            end)
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

-- kembalikan decal/transparency (tidak bisa tahu original semua, set ke 0)
task.spawn(function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            pcall(function() obj.Transparency = 0 end)
        end
    end
end)

end

-- Toggle button toggleBtn.MouseButton1Click:Connect(function() if lowGraphicsEnabled then disableLowGraphics() toggleBtn.Text = "Turn Low ON" else enableLowGraphics() toggleBtn.Text = "Turn Low OFF" end end)

-- FPS & Ping updater local fps = 0 local frameCount = 0 local accumulator = 0 local lastTime = tick()

RunService.RenderStepped:Connect(function(dt) frameCount = frameCount + 1 accumulator = accumulator + dt

-- update tiap 0.5s
if accumulator >= 0.5 then
    fps = math.floor(frameCount / accumulator + 0.5)
    frameCount = 0
    accumulator = 0

    -- try get ping (ms)
    local ping = "--"
    pcall(function()
        local net = Stats.Network
        if net and net:FindFirstChild("ServerStatsItem") then
            -- fallback
        end
        -- common path
        local item = Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
        if item then
            local v = item:GetValue()
            ping = math.floor(v + 0.5)
        else
            -- alternative: use legacy path
            local dataPing = Stats:FindFirstChild("Data Ping")
            if dataPing and typeof(dataPing.GetValue) == "function" then
                ping = math.floor(dataPing:GetValue() + 0.5)
            end
        end
    end)

    fpsLabel.Text = string.format("FPS: %s  |  PING: %s ms", tostring(fps), tostring(ping))
end

end)

-- Parent GUI screenGui.Parent = PlayerGui

-- Quick key: press RightCtrl + L to toggle low graphics (optional) local UserInputService = game:GetService("UserInputService") UserInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end if input.KeyCode == Enum.KeyCode.L and UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then toggleBtn:Activate() end end)

-- Finished print("Low Graphics GUI loaded")

