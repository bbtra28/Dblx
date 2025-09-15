-- Roblox Lua: Low graphics / disable effects + draggable GUI showing FPS & Ping -- Versi Executor (langsung inject, tanpa perlu StarterPlayerScripts)

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Lighting = game:GetService("Lighting") local Workspace = game:GetService("Workspace") local LocalPlayer = Players.LocalPlayer

-- CONFIG local UPDATE_INTERVAL = 0.2 -- detik update UI

local saved = { lighting = {}, postEffects = {}, particleStates = {}, } local effectsDisabled = false

local function safeSet(obj, prop, val) if obj and obj[prop] ~= nil then pcall(function() obj[prop] = val end) end end

local function disablePostEffects() for _, v in pairs(Lighting:GetDescendants()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then saved.postEffects[v] = {Enabled = v.Enabled} safeSet(v, "Enabled", false) end end end

local function restorePostEffects() for v, state in pairs(saved.postEffects) do if v and v.Parent then safeSet(v, "Enabled", state.Enabled) end end saved.postEffects = {} end

local function disableParticlesAndMisc() for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then saved.particleStates[obj] = obj.Enabled safeSet(obj, "Enabled", false) end end end

local function restoreParticlesAndMisc() for obj, state in pairs(saved.particleStates) do if obj and obj.Parent then safeSet(obj, "Enabled", state) end end saved.particleStates = {} end

local function applyLowLighting() local props = {"GlobalShadows", "Brightness", "OutdoorAmbient", "ClockTime", "FogEnd", "EnvironmentDiffuseScale", "EnvironmentSpecularScale"} for _, p in ipairs(props) do saved.lighting[p] = Lighting[p] end

safeSet(Lighting, "GlobalShadows", false)
safeSet(Lighting, "Brightness", 1)
safeSet(Lighting, "OutdoorAmbient", Color3.fromRGB(127,127,127))
safeSet(Lighting, "ClockTime", 12)
safeSet(Lighting, "FogEnd", 100000)
safeSet(Lighting, "EnvironmentDiffuseScale", 0)
safeSet(Lighting, "EnvironmentSpecularScale", 0)

pcall(function() settings().Rendering.QualityLevel = 1 end)

end

local function restoreLighting() for p, v in pairs(saved.lighting) do safeSet(Lighting, p, v) end saved.lighting = {} pcall(function() settings().Rendering.QualityLevel = 14 end) end

local function enableLowGraphics() if effectsDisabled then return end disablePostEffects() disableParticlesAndMisc() applyLowLighting() effectsDisabled = true end

local function disableLowGraphics() if not effectsDisabled then return end restorePostEffects() restoreParticlesAndMisc() restoreLighting() effectsDisabled = false end

local function getPing() local ok, result = pcall(function() local Stats = game:GetService("Stats") if Stats and Stats:FindFirstChild("Network") then local net = Stats.Network local pingObj = net:FindFirstChild("Data Ping") or net:FindFirstChild("DataPing") or net:FindFirstChild("Ping") if pingObj then if typeof(pingObj.Value) == "number" then return math.floor(pingObj.Value) end if pingObj.GetValueString then local s = pingObj:GetValueString() local n = tonumber(s:match("%d+")) if n then return n end end end end if LocalPlayer and LocalPlayer.GetNetworkPing then return math.floor(LocalPlayer:GetNetworkPing()*1000) end end) if ok and result then return result end return 0 end

-- GUI local function createGui() local pg = LocalPlayer:WaitForChild("PlayerGui", 10) if not pg then return end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LowGraphicsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 90)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.25
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Low Graphics (drag)"
title.Size = UDim2.new(1, -8, 0, 24)
title.Position = UDim2.new(0, 4, 0, 4)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Text = "FPS: --"
fpsLabel.Size = UDim2.new(0.5, -6, 0, 20)
fpsLabel.Position = UDim2.new(0, 4, 0, 32)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextSize = 14
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = frame

local pingLabel = Instance.new("TextLabel")
pingLabel.Text = "Ping: -- ms"
pingLabel.Size = UDim2.new(0.5, -6, 0, 20)
pingLabel.Position = UDim2.new(0.5, 2, 0, 32)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.new(1,1,1)
pingLabel.Font = Enum.Font.SourceSans
pingLabel.TextSize = 14
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "Enable"
toggleBtn.Size = UDim2.new(1, -8, 0, 26)
toggleBtn.Position = UDim2.new(0, 4, 0, 56)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.Parent = frame

-- Draggable
local dragging, dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateInput(input) end
end)

-- Toggle logic
toggleBtn.MouseButton1Click:Connect(function()
    if effectsDisabled then
        disableLowGraphics()
        toggleBtn.Text = "Enable"
    else
        enableLowGraphics()
        toggleBtn.Text = "Disable"
    end
end)

-- FPS & Ping update loop
local frames = 0
RunService.RenderStepped:Connect(function() frames = frames + 1 end)
task.spawn(function()
    while task.wait(UPDATE_INTERVAL) do
        local fpsVal = math.floor(frames / UPDATE_INTERVAL + 0.5)
        frames = 0
        local pingVal = getPing()
        fpsLabel.Text = "FPS: " .. fpsVal
        pingLabel.Text = "Ping: " .. pingVal .. " ms"
    end
end)

end

-- Jalankan GUI createGui()

print("Low Graphics + FPS/Ping GUI Loaded (Executor Mode)")

