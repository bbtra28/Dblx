-- Local-only: Strong Invisible (Executor-friendly)
-- Toggle GUI / Hotkey X / Draggable
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiName = "StrongInvisGui"

-- cleanup old
pcall(function()
    local pg = player:FindFirstChildOfClass("PlayerGui")
    if pg and pg:FindFirstChild(guiName) then pg[guiName]:Destroy() end
end)

-- helper
local function new(class, props)
    local o = Instance.new(class)
    if props then for k,v in pairs(props) do o[k]=v end end
    return o
end

local screen = new("ScreenGui",{Name=guiName,Parent=player:WaitForChild("PlayerGui"),ResetOnSpawn=false,IgnoreGuiInset=true})
local frame = new("Frame",{Parent=screen,Size=UDim2.new(0,260,0,130),Position=UDim2.new(0.02,0,0.15,0),BackgroundColor3=Color3.fromRGB(30,30,30),BorderSizePixel=0})
new("UICorner",{Parent=frame,CornerRadius=UDim.new(0,10)})
new("TextLabel",{Parent=frame,Text="Strong Invisible (Local)",Size=UDim2.new(1,-20,0,28),Position=UDim2.new(0,10,6),BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=14,TextColor3=Color3.fromRGB(230,230,230)})
local btnOn = new("TextButton",{Parent=frame,Text="Invisible (Local)",Size=UDim2.new(0,120,0,36),Position=UDim2.new(0,10,0,42),BackgroundColor3=Color3.fromRGB(45,45,45)})
local btnOff = new("TextButton",{Parent=frame,Text="Visible",Size=UDim2.new(0,120,0,36),Position=UDim2.new(0,140,0,42),BackgroundColor3=Color3.fromRGB(45,45,45)})
local status = new("TextLabel",{Parent=frame,Text="Status: Visible",Size=UDim2.new(1,-20,0,20),Position=UDim2.new(0,10,1,-28),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=12,TextColor3=Color3.fromRGB(180,180,180)})
local hint = new("TextLabel",{Parent=frame,Text="Hotkey: X",Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,10,1,-44),BackgroundTransparency=1,Font=Enum.Font.Gotham,TextSize=11,TextColor3=Color3.fromRGB(160,160,160)})

-- draggable
do
    local dragging=false; local dragInput; local dragStart; local startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dragStart=i.Position; startPos=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i==dragInput then
        local delta = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
end

-- core functions
local isInvisible = false

local function applyLocalInvis(character)
    if not character then return end
    -- BaseParts: use LocalTransparencyModifier (client-side)
    for _,part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            -- save original local mod if not saved
            if part:GetAttribute("orig_localmod")==nil then
                part:SetAttribute("orig_localmod", part.LocalTransparencyModifier or 0)
            end
            pcall(function() part.LocalTransparencyModifier = 1 end)
            -- optionally hide shadow by disabling CastShadow (client-side effect)
            if part:GetAttribute("orig_castshadow")==nil then part:SetAttribute("orig_castshadow", part.CastShadow) end
            pcall(function() part.CastShadow = false end)
        elseif part:IsA("Decal") or part:IsA("Texture") then
            if part:GetAttribute("orig_transparency")==nil then part:SetAttribute("orig_transparency", part.Transparency or 0) end
            pcall(function() part.Transparency = 1 end)
        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
            if part:GetAttribute("orig_enabled")==nil then part:SetAttribute("orig_enabled", part.Enabled) end
            pcall(function() part.Enabled = false end)
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            if part:GetAttribute("orig_enabled")==nil then part:SetAttribute("orig_enabled", part.Enabled) end
            pcall(function() part.Enabled = false end)
        elseif part:IsA("Accessory") then
            if part:GetAttribute("orig_parent")==nil then part:SetAttribute("orig_parent", part.Parent) end
            pcall(function() part.Parent = nil end) -- local removal (may only affect client rendering)
        end
    end

    -- hide humanoid name display
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid:GetAttribute("orig_display")==nil then humanoid:SetAttribute("orig_display", humanoid.DisplayDistanceType) end
        pcall(function() humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
    end

    status.Text = "Status: Invisible (local)"
    isInvisible = true
end

local function restoreLocalVisible(character)
    if not character then return end
    for _,part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local orig = part:GetAttribute("orig_localmod")
            if orig ~= nil then pcall(function() part.LocalTransparencyModifier = orig end) end
            local origcs = part:GetAttribute("orig_castshadow")
            if origcs ~= nil then pcall(function() part.CastShadow = origcs end) end
        elseif part:IsA("Decal") or part:IsA("Texture") then
            local orig = part:GetAttribute("orig_transparency")
            if orig ~= nil then pcall(function() part.Transparency = orig end) end
        elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            local orig = part:GetAttribute("orig_enabled")
            if orig ~= nil then pcall(function() part.Enabled = orig end) end
        elseif part:IsA("Accessory") then
            local origp = part:GetAttribute("orig_parent")
            if origp then
                -- try to reparent if original parent still exists
                pcall(function() part.Parent = origp end)
            end
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local orig = humanoid:GetAttribute("orig_display")
        if orig then pcall(function() humanoid.DisplayDistanceType = orig end) end
    end

    status.Text = "Status: Visible"
    isInvisible = false
end

-- buttons
btnOn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    applyLocalInvis(char)
end)
btnOff.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    restoreLocalVisible(char)
end)

-- hotkey X toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.X then
        local char = player.Character or player.CharacterAdded:Wait()
        if isInvisible then restoreLocalVisible(char) else applyLocalInvis(char) end
    end
end)

-- reapply on respawn if was invisible
player.CharacterAdded:Connect(function(char)
    wait(0.2)
    if isInvisible then
        pcall(function() applyLocalInvis(char) end)
    else
        pcall(function() restoreLocalVisible(char) end)
    end
end)

print("[StrongInvis] siap — ini hanya local (client-side). Tidak membuatmu invisible untuk pemain lain.")
