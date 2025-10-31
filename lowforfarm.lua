-- 🌐 Roblox Data Saver GUI (Auto Aktif + Draggable + Save Posisi + FPS/Ping Monitor)
-- 💻 Kompatibel semua executor: Arceus X, Delta, VegaX, Fluxus, Hydrogen, Codex

task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")
    local SoundService = game:GetService("SoundService")
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Stats = game:GetService("Stats")
    local LocalPlayer = Players.LocalPlayer
    local enabled = true

    -- 📦 Simpan posisi GUI antar sesi
    local function SavePos(x, y)
        pcall(function()
            LocalPlayer:SetAttribute("DataSaver_PosX", x)
            LocalPlayer:SetAttribute("DataSaver_PosY", y)
        end)
    end

    local function LoadPos()
        local x = LocalPlayer:GetAttribute("DataSaver_PosX")
        local y = LocalPlayer:GetAttribute("DataSaver_PosY")
        if x and y then
            return UDim2.new(0, x, 0, y)
        else
            return UDim2.new(0.8, 0, 0.1, 0)
        end
    end

    -- 🪟 GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "DataSaverGUI"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 80)
    frame.Position = LoadPos()
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔴 Data Saver: ON"
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255,100,100)
    title.Parent = frame

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0.5, 0)
    info.Position = UDim2.new(0, 0, 0.5, 0)
    info.BackgroundTransparency = 1
    info.Text = "FPS: 0 | Ping: 0ms"
    info.Font = Enum.Font.SourceSansBold
    info.TextScaled = true
    info.TextColor3 = Color3.fromRGB(255,255,255)
    info.Parent = frame

    -- ✅ Draggable GUI + save posisi
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        frame.Position = newPos
        SavePos(newPos.X.Offset, newPos.Y.Offset)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- ⚙️ Fungsi low graphic
    local function EnableLowGraphics()
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
            Lighting.FogStart = 0
            Lighting.FogEnd = 1e6
            Lighting.Ambient = Color3.fromRGB(120,120,120)
            Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)
            Lighting.EnvironmentDiffuseScale = 0
            Lighting.EnvironmentSpecularScale = 0
            Lighting.ClockTime = 12

            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or
                   v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or
                   v:IsA("DepthOfFieldEffect") then
                    v.Enabled = false
                end
            end

            for _, s in ipairs(SoundService:GetDescendants()) do
                if s:IsA("Sound") then s.Volume = 0 end
            end

            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
                or obj:IsA("Smoke") or obj:IsA("Fire")
                or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0.8
                elseif obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                end
            end

            if Workspace:FindFirstChildOfClass("Terrain") then
                local t = Workspace.Terrain
                t.WaterWaveSize = 0
                t.WaterWaveSpeed = 0
                t.WaterReflectance = 0
                t.WaterTransparency = 1
            end
        end)
    end

    local function DisableLowGraphics()
        pcall(function()
            Lighting.GlobalShadows = true
            Lighting.Brightness = 2
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
        end)
    end

    -- 🔘 Toggle lewat klik judul
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if enabled then
                DisableLowGraphics()
                title.Text = "🟢 Data Saver: OFF"
                title.TextColor3 = Color3.fromRGB(100,255,100)
            else
                EnableLowGraphics()
                title.Text = "🔴 Data Saver: ON"
                title.TextColor3 = Color3.fromRGB(255,100,100)
            end
            enabled = not enabled
        end
    end)

    -- 🚀 Auto aktif
    game.Loaded:Wait()
    task.wait(1)
    EnableLowGraphics()

    -- 📊 FPS + Ping real-time
    local lastUpdate = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount / (tick() - lastUpdate)
            frameCount = 0
            lastUpdate = tick()

            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            info.Text = string.format("FPS: %d | Ping: %dms", math.floor(fps), ping)
        end
    end)
end)
