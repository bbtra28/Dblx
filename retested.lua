-- Simple Local Invisible Toggle (On/Off) + Draggable GUI
-- Untuk executor (Arceus X, Fluxus, dll.)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiName = "SimpleInvisToggle"

-- cleanup old GUI
pcall(function()
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if pg and pg:FindFirstChild(guiName) then pg[guiName]:Destroy() end
end)

-- helper create
local function new(class, props)
    local o = Instance.new(class)
    if props then for k,v in pairs(props) do o[k] = v end end
    return o
end

-- GUI
local screen = new("ScreenGui", {Name = guiName, Parent = player:WaitForChild("PlayerGui"), ResetOnSpawn = false, IgnoreGuiInset = true})
local frame = new("Frame", {
    Parent = screen,
    Size = UDim2.new(0, 220, 0, 98),
    Position = UDim2.new(0.02, 0, 0.18, 0),
    BackgroundColor3 = Color3.fromRGB(28,28,28),
    BorderSizePixel = 0
})
new("UICorner", {Parent = frame, CornerRadius = UDim.new(0,8)})
new("TextLabel", {
    Parent = frame,
    Text = "Invisible (Local)",
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0,8,0,6),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(230,230,230)
})

local toggleBtn = new("TextButton", {
    Parent = frame,
    Name = "Toggle",
    Text = "Turn ON",
    Size = UDim2.new(0, 100, 0, 36),
    Position = UDim2.new(0, 60, 0, 36),
    BackgroundColor3 = Color3.fromRGB(50,50,50),
    TextColor3 = Color3.fromRGB(230,230,230),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    AutoButtonColor = true
})

local status = new("TextLabel", {
    Parent = frame,
    Text = "Status: OFF",
    Size = UDim2.new(1, -16, 0, 16),
    Position = UDim2.new(0,8,1,-22),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(180,180,180)
})

-- draggable
do
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- invis functions (local)
local isOn = false

local function applyInvisible(character)
    if not character then return end
    for _,inst in pairs(character:GetDescendants()) do
        if inst:IsA("BasePart") then
            if inst:GetAttribute("orig_local") == nil then inst:SetAttribute("orig_local", inst.LocalTransparencyModifier or 0) end
            pcall(function() inst.LocalTransparencyModifier = 1 end)
            if inst:GetAttribute("orig_cast") == nil then inst:SetAttribute("orig_cast", inst.CastShadow) end
            pcall(function() inst.CastShadow = false end)
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            if inst:GetAttribute("orig_dec") == nil then inst:SetAttribute("orig_dec", inst.Transparency or 0) end
            pcall(function() inst.Transparency = 1 end)
        elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
            if inst:GetAttribute("orig_enabled") == nil then inst:SetAttribute("orig_enabled", inst.Enabled) end
            pcall(function() inst.Enabled = false end)
        elseif inst:IsA("Accessory") then
            if inst:GetAttribute("orig_parent") == nil then inst:SetAttribute("orig_parent", inst.Parent) end
            pcall(function() inst.Parent = nil end)
        end
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum:GetAttribute("orig_disp") == nil then hum:SetAttribute("orig_disp", hum.DisplayDistanceType) end
        pcall(function() hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
    end
end

local function restoreVisible(character)
    if not character then return end
    for _,inst in pairs(character:GetDescendants()) do
        if inst:IsA("BasePart") then
            local orig = inst:GetAttribute("orig_local")
            if orig ~= nil then pcall(function() inst.LocalTransparencyModifier = orig end) end
            local origc = inst:GetAttribute("orig_cast")
            if origc ~= nil then pcall(function() inst.CastShadow = origc end) end
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            local orig = inst:GetAttribute("orig_dec")
            if orig ~= nil then pcall(function() inst.Transparency = orig end) end
        elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
            local orig = inst:GetAttribute("orig_enabled")
            if orig ~= nil then pcall(function() inst.Enabled = orig end) end
        elseif inst:IsA("Accessory") then
            local origp = inst:GetAttribute("orig_parent")
            if origp and typeof(origp) ~= "Instance" then origp = nil end
            if origp then pcall(function() inst.Parent = origp end) end
        end
    end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        local orig = hum:GetAttribute("orig_disp")
        if orig ~= nil then pcall(function() hum.DisplayDistanceType = orig end) end
    end
end

-- toggle handler
local function toggle()
    local char = player.Character or player.CharacterAdded:Wait()
    if not isOn then
        applyInvisible(char)
        isOn = true
        toggleBtn.Text = "Turn OFF"
        status.Text = "Status: ON"
    else
        restoreVisible(char)
        isOn = false
        toggleBtn.Text = "Turn ON"
        status.Text = "Status: OFF"
    end
end

toggleBtn.MouseButton1Click:Connect(toggle)

-- maintain on respawn if was on
player.CharacterAdded:Connect(function(char)
    wait(0.2)
    if isOn then
        pcall(function() applyInvisible(char) end)
    else
        pcall(function() restoreVisible(char) end)
    end
end)

print("[SimpleInvisToggle] siap — On/Off + draggable. Hanya client-side.")
