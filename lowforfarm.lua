-- 🌐 Roblox Low Graphics + Data Saver (No Fog, No Sound)
-- Auto aktif saat dijalankan + GUI Toggle (Executor Version)

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local enabled = true

-- === BUAT GUI ===
local gui = Instance.new("ScreenGui")
gui.Name = "LowGraphicsGUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.8, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.3
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "🔴 Data Saver: ON"
button.TextColor3 = Color3.fromRGB(255,100,100)
button.Font = Enum.Font.SourceSansBold
button.TextScaled = true
button.BackgroundTransparency = 1
button.Parent = frame

-- === MODE HEMAT KUOTA + GRAFIS RENDAH ===
local function LowGraphics()
    pcall(function()
        -- Lighting (tanpa kabut)
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogStart = 0
        Lighting.FogEnd = 100000 -- tanpa kabut
        Lighting.Ambient = Color3.fromRGB(120,120,120)
        Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ClockTime = 12

        -- Matikan efek lighting berat
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect")
            or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end

        -- Matikan suara untuk hemat kuota
        for _,s in ipairs(SoundService:GetDescendants()) do
            if s:IsA("Sound") then
                s.Volume = 0
            end
        end

        -- Hemat data lewat streaming radius (muat area kecil saja)
        pcall(function()
            Workspace:SetAttribute("StreamingEnabled", true)
            Workspace.StreamingMinRadius = 20
            Workspace.StreamingTargetRadius = 60
        end)

        -- Hilangkan efek visual berat
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail")
            or obj:IsA("Smoke") or obj:IsA("Fire")
            or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0.8
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Reflectance = 0
                obj.Material = Enum.Material.SmoothPlastic
            end
        end

        -- Simplify terrain
        if Workspace:FindFirstChildOfClass("Terrain") then
            local t = Workspace.Terrain
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
            t.WaterReflectance = 0
            t.WaterTransparency = 1
        end

        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Data Saver] Mode hemat kuota & grafis rendah aktif 🌐",
            Color = Color3.fromRGB(255,200,0)
        })
    end)
end

-- === MODE NORMAL ===
local function RestoreGraphics()
    pcall(function()
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

        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect")
            or v:IsA("DepthOfFieldEffect") then
                v.Enabled = true
            end
        end

        -- Pulihkan suara
        for _,s in ipairs(SoundService:GetDescendants()) do
            if s:IsA("Sound") then
                s.Volume = 1
            end
        end

        -- Pulihkan lighting
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1

        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Data Saver] Mode normal dikembalikan 🔄",
            Color = Color3.fromRGB(100,255,100)
        })
    end)
end

-- === TOGGLE BUTTON ===
button.MouseButton1Click:Connect(function()
    if enabled then
        RestoreGraphics()
        button.Text = "🟢 Data Saver: OFF"
        button.TextColor3 = Color3.fromRGB(100,255,100)
    else
        LowGraphics()
        button.Text = "🔴 Data Saver: ON"
        button.TextColor3 = Color3.fromRGB(255,100,100)
    end
    enabled = not enabled
end)

-- === AUTO AKTIF ===
LowGraphics()
