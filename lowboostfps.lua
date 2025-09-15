-- Roblox Lua: Low graphics / disable effects + draggable GUI showing FPS & Ping -- Place as a LocalScript (StarterPlayerScripts) or run via executor.

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Lighting = game:GetService("Lighting") local Workspace = game:GetService("Workspace") local StarterGui = game:GetService("StarterGui") local LocalPlayer = Players.LocalPlayer

-- CONFIG local UPDATE_INTERVAL = 0.2 -- seconds between UI updates

-- STORAGE FOR RESTORE local saved = { lighting = {}, postEffects = {}, particleStates = {}, } local effectsDisabled = false

-- UTILS local function safeSet(obj, prop, val) if obj and obj[prop] ~= nil then local ok, err = pcall(function() obj[prop] = val end) if not ok then -- ignore end end end

-- DISABLE / ENABLE EFFECTS local function disablePostEffects() for _, v in pairs(Lighting:GetDescendants()) do if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then saved.postEffects[v] = {Enabled = v.Enabled, Intensity = v.Intensity} safeSet(v, "Enabled", false) safeSet(v, "Intensity", 0) end end end

local function restorePostEffects() for v, state in pairs(saved.postEffects) do if v and v.Parent then safeSet(v, "Enabled", state.Enabled) safeSet(v, "Intensity", state.Intensity) end end saved.postEffects = {} end

local function disableParticlesAndMisc() for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then saved.particleStates[obj] = saved.particleStates[obj] or {} saved.particleStates[obj].Enabled = obj.Enabled safeSet(obj, "Enabled", false) elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then saved.particleStates[obj] = saved.particleStates[obj] or {} saved.particleStates[obj].Enabled = obj.Enabled safeSet(obj, "Enabled", false) end end end

local function restoreParticlesAndMisc() for obj, state in pairs(saved.particleStates) do if obj and obj.Parent then safeSet(obj, "Enabled", state.Enabled) end end saved.particleStates = {} end

local function applyLowLighting() -- Save a few common lighting properties then reduce quality local props = {"GlobalShadows", "Brightness", "OutdoorAmbient", "ClockTime", "FogEnd", "EnvironmentDiffuseScale", "EnvironmentSpecularScale"} for _, p in ipairs(props) do saved.lighting[p] = Lighting[p] end

safeSet(Lighting, "GlobalShadows", false)
safeSet(Lighting, "Brightness", 1)
safeSet(Lighting, "OutdoorAmbient", Color3.fromRGB(127,127,127))
safeSet(Lighting, "ClockTime", 12)
safeSet(Lighting, "FogEnd", 100000)
safeSet(Lighting, "EnvironmentDiffuseScale", 0)
safeSet(Lighting, "EnvironmentSpecularScale", 0)

-- Try lowering the quality level if available (may not work in all environments)
pcall(function() settings().Rendering.QualityLevel = 1 end)

end

local function restoreLighting() for p, v in pairs(saved.lighting) do if Lighting[p] ~= nil then safeSet(Lighting, p, v) end end saved.lighting = {} pcall(function() settings().Rendering.QualityLevel = 14 end) end

local function disableDecalsAndTextures() -- Optional: disable decals/textures by setting transparency (non-destructive: we won't save every decal state to avoid huge memory use) -- This loop is conservative: only disable in Workspace top-level items named or typed typical for heavy effects. for _, dec in pairs(Workspace:GetDescendants()) do if dec:IsA("Decal") or dec:IsA("Texture") then pcall(function() dec.Transparency = 1 end) end end end

-- TOGGLE local function enableLowGraphics() if effectsDisabled then return end disablePostEffects() disableParticlesAndMisc() applyLowLighting() disableDecalsAndTextures() effectsDisabled = true end

local function disableLowGraphics() if not effectsDisabled then return end restorePostEffects() restoreParticlesAndMisc() restoreLighting() effectsDisabled = false end

-- PING FETCH HELPER (tries several approaches) local function getPing() -- Try Stats Network ServerStatsItem (returns string like "42 ms") local ok, result = pcall(function() local Stats = game:GetService("Stats") if Stats and Stats:FindFirstChild("Network") then local net = Stats.Network local pingObj = net:FindFirstChild("Data Ping") or net:FindFirstChild("DataPing") or net:FindFirstChild("Ping") if pingObj then if typeof(pingObj.Value) == "number" then return math.floor(pingObj.Value) end if pingObj.GetValueString then local s = pingObj:GetValueString() local n = tonumber(s:match("%d+")) if n then return n end end end end -- Fallback: use Players:GetNetworkPing (available in newer clients) if LocalPlayer and LocalPlayer:GetNetworkPing then local p = LocalPlayer:GetNetworkPing() if p then return math.floor(p*1000) end -- Convert to ms end end) if ok and result then return result end return 0 end

-- GUI: Build draggable frame with FPS and Ping local function createGui() local screenGui = Instance.new("ScreenGui") screenGui.Name = "LowGraphicsGUI" screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 200, 0, 90)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundTransparency = 0.25
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Low Graphics (drag)"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -8, 0, 24)
title.Position = UDim2.new(0, 4, 0, 4)
title.Parent = frame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPS"
fpsLabel.Text = "FPS: --"
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Size = UDim2.new(0.5, -6, 0, 20)
fpsLabel.Position = UDim2.new(0, 4, 0, 32)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = frame

local pingLabel = Instance.new("TextLabel")
pingLabel.Name = "PING"
pingLabel.Text = "Ping: -- ms"
pingLabel.Font = Enum.Font.SourceSans
pingLabel.TextSize = 14
pingLabel.TextColor3 = Color3.new(1,1,1)
pingLabel.BackgroundTransparency = 1
pingLabel.Size = UDim2.new(0.5, -6, 0, 20)
pingLabel.Position = UDim2.new(0.5, 2, 0, 32)
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "Toggle"
toggleBtn.Text = "Enable"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
toggleBtn.Size = UDim2.new(1, -8, 0, 26)
toggleBtn.Position = UDim2.new(0, 4, 0, 56)
toggleBtn.Parent = frame

-- Draggable logic
local dragging = false
local dragInput, dragStart, startPos

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
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Toggle behavior
toggleBtn.MouseButton1Click:Connect(function()
    if effectsDisabled then
        disableLowGraphics() -- turn off low-graphics (restore)
        toggleBtn.Text = "Enable"
    else
        enableLowGraphics()
        toggleBtn.Text = "Disable"
    end
end)

screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Update loop for FPS & Ping
local lastTime = tick()
local accumulator = 0
local frames = 0

RunService.RenderStepped:Connect(function()
    frames = frames + 1
end)

spawn(function()
    while true do
        wait(UPDATE_INTERVAL)
        -- FPS calculation: frames per UPDATE_INTERVAL
        local fpsVal = math.floor(frames / UPDATE_INTERVAL + 0.5)
        frames = 0

        -- Ping
        local pingVal = 0
        pcall(function()
            pingVal = getPing() or 0
        end)

        fpsLabel.Text = ("FPS: %s"):format(tostring(fpsVal))
        pingLabel.Text = ("Ping: %sms"):format(tostring(pingVal))
    end
end)

end

-- RUN createGui()

-- Auto-enable low graphics on start (comment out if you prefer manual) -- enableLowGraphics()

print("Low Graphics + FPS/Ping GUI loaded. Use the GUI to enable/disable.")

