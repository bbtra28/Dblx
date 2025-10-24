-- 🌐 FastLoad + Low Graphics + Data Saver (Draggable GUI)
-- Optimized for mobile executors (Arceus X, Delta, VegaX, Fluxus)

task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")
    local SoundService = game:GetService("SoundService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local enabled = true

    -- 🚀 Streaming agar load cepat & hemat kuota
    pcall(function()
        Workspace:SetAttribute("StreamingEnabled", true)
        Workspace.StreamingMinRadius = 10
        Workspace.StreamingTargetRadius = 45
    end)

    -- 🪟 GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "DataSaverGUI"
    gui.ResetOnSpawn = false
    gui.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 50)
    frame.Position = UDim2.new(0.8, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.25
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.TextColor3 = Color3.fromRGB(255,100,100)
    button.Text = "🔴 Data Saver: ON"
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.Parent = frame

    -- 🧩 Fungsi aktif mode hemat
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

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[Data Saver] Mode aktif 🌐 (hemat kuota & cepat)",
                Color = Color3.fromRGB(255,200,0)
            })
        end)
    end

    -- 🧩 Fungsi kembalikan normal
    local function DisableLowGraphics()
        pcall(function()
            Lighting.GlobalShadows = true
            Lighting.Brightness = 2
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1

            for _, s in ipairs(SoundService:GetDescendants()) do
                if s:IsA("Sound") then s.Volume = 1 end
            end

            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
                or obj:IsA("Smoke") or obj:IsA("Fire")
                or obj:IsA("Sparkles") then
                    obj.Enabled = true
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = true
                end
            end

            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[Data Saver] Mode dimatikan 🔄",
                Color = Color3.fromRGB(100,255,100)
            })
        end)
    end

    -- 🎛️ Tombol toggle
    button.MouseButton1Click:Connect(function()
        if enabled then
            DisableLowGraphics()
            button.Text = "🟢 Data Saver: OFF"
            button.TextColor3 = Color3.fromRGB(100,255,100)
        else
            EnableLowGraphics()
            button.Text = "🔴 Data Saver: ON"
            button.TextColor3 = Color3.fromRGB(255,100,100)
        end
        enabled = not enabled
    end)

    -- 🚀 Jalankan otomatis setelah game siap
    game.Loaded:Wait()
    task.wait(1)
    EnableLowGraphics()
end)
