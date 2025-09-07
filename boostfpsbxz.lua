--// FPS Boost & Low Graphic
--// Buat dipakai di executor Roblox
--// Penulis: ChatGPT

local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- Coba lock FPS ke 60 (bisa diganti 120 kalau mau)
if type(setfpscap) == "function" then
    setfpscap(60) -- ganti 120 kalau mau lock 120fps
end

-- Nonaktifkan efek lighting yang bikin berat
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e5
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.fromRGB(200,200,200)
    Lighting.Ambient = Color3.fromRGB(200,200,200)
    
    -- Matikan semua efek post-processing
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end
end)

-- Buat terrain jadi lebih ringan
pcall(function()
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end
end)

-- Nonaktifkan decal & texture berat
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj.Lifetime = NumberRange.new(0)
        obj.Enabled = false
    elseif obj:IsA("Explosion") then
        obj.Visible = false
    end
end

-- Atur quality rendering (hanya jalan di beberapa executor)
pcall(function()
    if sethiddenproperty then
        sethiddenproperty(game:GetService("Lighting"), "Technology", Enum.Technology.Compatibility)
    end
end)

-- Tambahkan GUI kecil untuk toggle On/Off
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FPSBoostGui"
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "FPS Boost: ON"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Active = true
button.Draggable = true

local boosted = true

button.MouseButton1Click:Connect(function()
    if boosted then
        -- Restore normal
        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = true
            end
        end
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1000
        Lighting.Brightness = 2

        boosted = false
        button.Text = "FPS Boost: OFF"
    else
        -- Apply lagi low graphics
        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e5
        Lighting.Brightness = 1

        boosted = true
        button.Text = "FPS Boost: ON"
    end
end)