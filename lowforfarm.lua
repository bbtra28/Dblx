-- 🌐 Roblox Data Saver GUI v3 (Auto Aktif + Loading Render + Draggable + FPS/Ping lowercase + Fix)
-- 💻 Kompatibel: Arceus X, Delta, VegaX, Fluxus, Hydrogen, Codex

task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
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
    frame.Size = UDim2.new(0, 200, 0, 90)
    frame.Position = LoadPos()
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.Active = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚙️ rendering low graphic..."
    title.Font = Enum.Font.SourceSansBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255,255,100)
    title.Parent = frame

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0.5, 0)
    info.Position = UDim2.new(0, 0, 0.5, 0)
    info.BackgroundTransparency = 1
    info.Text = "fps: 0 | ping: 0ms"
    info.Font = Enum.Font.SourceSansBold
    info.TextScaled = true
    info.TextColor3 = Color3.fromRGB(255,255,255)
    info.Parent = frame

    -- ✅ Draggable GUI + simpan posisi
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
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

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
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

    -- 🔘 Toggle lewat klik judul
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if enabled then
                enabled = false
                title.Text = "🟢 data saver: off"
                title.TextColor3 = Color3.fromRGB(100,255,100)
            else
                enabled = true
                EnableLowGraphics()
                title.Text = "🔴 data saver: on"
                title.TextColor3 = Color3.fromRGB(255,100,100)
            end
        end
    end)

    -- 🚀 Efek loading render
    task.spawn(function()
        for i = 1, 3 do
            title.Text = "⚙️ rendering low graphic" .. string.rep(".", i)
            task.wait(0.4)
        end
        EnableLowGraphics()
        title.Text = "🔴 data saver: on"
        title.TextColor3 = Color3.fromRGB(255,100,100)
    end)

    -- 📊 FPS + Ping real-time (fix tanpa error)
    local lastUpdate = tick()
    local frameCount = 0
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount / (tick() - lastUpdate)
            frameCount = 0
            lastUpdate = tick()

            local pingStat = Stats.Network:FindFirstChild("ServerStatsItem") and Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0

            info.Text = string.format("fps: %d | ping: %dms", math.floor(fps), ping)
        end
    end)
end)
