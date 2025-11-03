-- HandFan: Hunty Zombie — Full Auto GUI (Auto Kill, Auto Collect, Auto Door, Fast Attack Toggle)
-- Compatible with many executors (Arceus X, Fluxus, Delta, etc.)
-- NOTE: gunakan dengan bijak — terlalu agresif bisa menimbulkan lag / anti-cheat

-- ========== CONFIG ==========
local SAVE_FILE = "huntyzombie_gui_pos.json"
local AUTO_ATTACK_RANGE = 60
local ATTACK_INTERVAL = 0.15
local TELEPORT_SAFE_POS = {
    ["Spawn"] = Vector3.new(0, 10, 0),
    ["SafeZone"] = Vector3.new(100, 10, 100)
}
local HITBOX_NAMES = {"HumanoidRootPart", "Head", "Torso", "Hitbox"}
local DROP_TAGS = {"Drop","Item","Coin","Loot"}

-- Auto open door config
local AUTO_OPEN_RANGE = 8
local DOOR_TAGS = {"Door","Gate","Entrance","Portal","Pintu","Handle","DoorHandle","GateHandle"}

-- Fast attack config defaults
local FAST_ATTACK_ENABLED_DEFAULT = false
local FAST_ATTACK_BURST_DEFAULT = 4
local FAST_ATTACK_DELAY_DEFAULT = 0.03
local FAST_ATTACK_COOLDOWN_DEFAULT = 0.12

-- ========== SERVICES & UTIL ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function safe_readfile(path)
    if readfile then
        local ok, data = pcall(readfile, path)
        if ok then return data end
    end
    return nil
end
local function safe_writefile(path, data)
    if writefile then
        pcall(writefile, path, data)
    end
end

local function getCharacter()
    return LocalPlayer and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
end

local function isNameDoor(name)
    if not name then return false end
    local lname = tostring(name):lower()
    for _, tag in ipairs(DOOR_TAGS) do
        if string.find(lname, tag:lower()) then return true end
    end
    return false
end

-- ========== TARGET / DROP / DOOR LOGIC ==========
local function getNearestNPC(maxDist)
    local char = getCharacter()
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not hrp then return nil end
    local closest, cDist = nil, math.huge
    for _, model in pairs(workspace:GetDescendants()) do
        if model and model:IsA("Model") and model ~= char then
            local humanoid = model:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health and humanoid.Health > 0 then
                local part = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (part.Position - hrp.Position).Magnitude
                    if dist < maxDist and dist < cDist then
                        local isPlayerModel = false
                        for _, p in pairs(Players:GetPlayers()) do
                            if p.Character == model then isPlayerModel = true; break end
                        end
                        if not isPlayerModel then
                            closest = model
                            cDist = dist
                        end
                    end
                end
            end
        end
    end
    return closest
end

local function getTargetHitbox(model)
    for _, name in ipairs(HITBOX_NAMES) do
        local p = model:FindFirstChild(name, true)
        if p and p:IsA("BasePart") then return p end
    end
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then return v end
    end
    return nil
end

local function collectNearbyDrops()
    local char = getCharacter()
    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
    if not hrp then return end
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part ~= hrp then
            local name = part.Name:lower()
            for _, tag in ipairs(DROP_TAGS) do
                if string.find(name, tag:lower()) then
                    pcall(function()
                        if firetouchinterest then
                            firetouchinterest(part, hrp, 0)
                            task.wait(0.02)
                            firetouchinterest(part, hrp, 1)
                        else
                            part.CFrame = hrp.CFrame + Vector3.new(0, -2, 0)
                        end
                    end)
                end
            end
        end
    end
end

-- Door helpers
local function tryFireProximityPrompt(prompt)
    if not prompt then return false end
    local success = false
    pcall(function()
        if fireproximityprompt and typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
            success = true
            return
        end
        if prompt and prompt:IsA("ProximityPrompt") then
            if pcall(function() prompt:InputHoldBegin() end) then
                task.wait(0.05)
                pcall(function() prompt:InputHoldEnd() end)
                success = true
                return
            end
            if pcall(function() prompt.HoldBegin(prompt) end) then
                task.wait(0.05)
                pcall(function() prompt.HoldEnd(prompt) end)
                success = true
                return
            end
        end
    end)
    return success
end

local function tryFireClickDetector(detector)
    if not detector then return false end
    local success = false
    pcall(function()
        if fireclickdetector and typeof(fireclickdetector) == "function" then
            fireclickdetector(detector)
            success = true
            return
        end
        local parent = detector.Parent
        if parent and parent:IsA("BasePart") then
            local char = getCharacter()
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
            if hrp then
                local orig = hrp.CFrame
                hrp.CFrame = CFrame.new(parent.Position + Vector3.new(0,3,0))
                task.wait(0.05)
                hrp.CFrame = orig
                success = true
                return
            end
        end
    end)
    return success
end

local function attemptOpenDoor(doorObj)
    if not doorObj then return false end
    for _, d in pairs(doorObj:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            if tryFireProximityPrompt(d) then return true end
        elseif d:IsA("ClickDetector") then
            if tryFireClickDetector(d) then return true end
        end
    end
    if doorObj:IsA("BasePart") then
        local char = getCharacter()
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
        if hrp then
            if firetouchinterest then
                pcall(function()
                    firetouchinterest(doorObj, hrp, 0)
                    task.wait(0.03)
                    firetouchinterest(doorObj, hrp, 1)
                end)
                return true
            else
                local orig = hrp.CFrame
                pcall(function() hrp.CFrame = CFrame.new(doorObj.Position + Vector3.new(0,3,0)) end)
                task.wait(0.05)
                pcall(function() hrp.CFrame = orig end)
                return true
            end
        end
    end
    return false
end

local function scanAndOpenNearbyDoors(range)
    local char = getCharacter()
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        local candidate = nil
        if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Folder") then
            if isNameDoor(obj.Name) then
                candidate = obj
            else
                for _, d in pairs(obj:GetDescendants()) do
                    if d:IsA("ProximityPrompt") or d:IsA("ClickDetector") then
                        candidate = obj
                        break
                    end
                end
            end
        end
        if candidate then
            local part = candidate:IsA("BasePart") and candidate or candidate:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (part.Position - hrp.Position).Magnitude
                if dist <= range then
                    pcall(function() attemptOpenDoor(candidate) end)
                end
            end
        end
    end
end

-- ========== ATTACK: touch + tool activation + fast mode ==========
local function touchPartBasic(targetPart)
    local char = getCharacter()
    if not char or not targetPart then return end
    local humanoidRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not humanoidRoot then return end
    if firetouchinterest and typeof(firetouchinterest) == "function" then
        pcall(function()
            firetouchinterest(targetPart, humanoidRoot, 0)
            task.wait(0.03)
            firetouchinterest(targetPart, humanoidRoot, 1)
        end)
        return
    end
    pcall(function()
        local orig = humanoidRoot.CFrame
        humanoidRoot.CFrame = CFrame.new(targetPart.Position + Vector3.new(0,3,0))
        task.wait(0.06)
        humanoidRoot.CFrame = orig
    end)
end

local function tryActivateTool()
    local char = getCharacter()
    if not char then return end
    local tool = nil
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then tool = v; break end
    end
    if not tool then
        local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, v in pairs(backpack:GetChildren()) do
                if v:IsA("Tool") then
                    tool = v
                    pcall(function() v.Parent = char end)
                    break
                end
            end
        end
    end
    if tool then
        pcall(function()
            if tool.Parent then
                tool:Activate()
            end
        end)
    end
end

-- fast attack helpers
local FAST_ATTACK_ENABLED = FAST_ATTACK_ENABLED_DEFAULT
local FAST_ATTACK_BURST = FAST_ATTACK_BURST_DEFAULT
local FAST_ATTACK_DELAY = FAST_ATTACK_DELAY_DEFAULT
local FAST_ATTACK_COOLDOWN = FAST_ATTACK_COOLDOWN_DEFAULT

local function tryActivateToolFast()
    local char = getCharacter()
    if not char then return end
    local tool = nil
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then tool = v; break end
    end
    if not tool then
        local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, v in pairs(backpack:GetChildren()) do
                if v:IsA("Tool") then
                    tool = v
                    pcall(function() v.Parent = char end)
                    break
                end
            end
        end
    end
    if tool then
        pcall(function()
            for i = 1, FAST_ATTACK_BURST do
                if tool and tool.Parent then
                    pcall(function() tool:Activate() end)
                end
                task.wait(FAST_ATTACK_DELAY)
            end
        end)
    end
end

local function touchPartFast(targetPart, bursts)
    local char = getCharacter()
    if not char or not targetPart then return end
    local humanoidRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not humanoidRoot then return end
    bursts = bursts or FAST_ATTACK_BURST
    if firetouchinterest and typeof(firetouchinterest) == "function" then
        pcall(function()
            for i = 1, bursts do
                firetouchinterest(targetPart, humanoidRoot, 0)
                task.wait(0.02)
                firetouchinterest(targetPart, humanoidRoot, 1)
                task.wait(FAST_ATTACK_DELAY)
            end
        end)
        return
    end
    pcall(function()
        local orig = humanoidRoot.CFrame
        local ok, pos = pcall(function() return targetPart.Position end)
        if ok and pos then
            humanoidRoot.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            for i = 1, bursts do
                task.wait(FAST_ATTACK_DELAY)
                tryActivateToolFast()
            end
            humanoidRoot.CFrame = orig
        end
    end)
end

-- ========== GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HuntyZombieGUI_" .. tostring(math.random(1,9999))
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame", screenGui)
main.Name = "Main"
main.Size = UDim2.new(0, 420, 0, 300)
main.Position = UDim2.new(0.02, 0, 0.12, 0)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

do
    local ok, data = pcall(function() return safe_readfile(SAVE_FILE) end)
    if ok and data then
        local suc, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if suc and decoded and decoded.x then
            main.Position = UDim2.new(0, decoded.x, 0, decoded.y)
        end
    end
end

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 34)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Hunty Zombie — Auto GUI (Final)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local function makeButton(text, posX, posY, parent)
    parent = parent or main
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 200, 0, 34)
    b.Position = UDim2.new(0, posX, 0, posY)
    b.Text = text
    b.TextSize = 14
    b.Font = Enum.Font.Gotham
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.BorderSizePixel = 0
    return b
end

local autoKillBtn = makeButton("Auto Kill: OFF", 10, 44)
local autoCollectBtn = makeButton("Auto Collect: OFF", 210, 44)
local autoDoorBtn = makeButton("Auto Door: OFF", 10, 88)
local fastAttackBtn = makeButton("Fast Attack: OFF", 210, 88)
local teleportBtn = makeButton("Teleport", 10, 134)
local hideBtn = makeButton("Hide GUI", 10, 248)
local saveBtn = makeButton("Save GUI Pos", 210, 248)

-- Teleport area container
local tpMenu = Instance.new("Frame", main)
tpMenu.Size = UDim2.new(0, 200, 0, 96)
tpMenu.Position = UDim2.new(0, 210, 0, 134)
tpMenu.BackgroundColor3 = Color3.fromRGB(35,35,35)
tpMenu.BorderSizePixel = 0

local tpTitle = Instance.new("TextLabel", tpMenu)
tpTitle.Size = UDim2.new(1, -8, 0, 20)
tpTitle.Position = UDim2.new(0, 4, 0, 4)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "Teleports"
tpTitle.TextColor3 = Color3.new(1,1,1)
tpTitle.Font = Enum.Font.Gotham
tpTitle.TextSize = 14
tpTitle.TextXAlignment = Enum.TextXAlignment.Left

local yOff = 28
for name, vec in pairs(TELEPORT_SAFE_POS) do
    local tbtn = Instance.new("TextButton", tpMenu)
    tbtn.Size = UDim2.new(1, -8, 0, 22)
    tbtn.Position = UDim2.new(0, 4, 0, yOff)
    tbtn.Text = name
    tbtn.Font = Enum.Font.Gotham
    tbtn.TextSize = 12
    tbtn.TextColor3 = Color3.new(1,1,1)
    tbtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    tbtn.BorderSizePixel = 0
    yOff = yOff + 26
    tbtn.MouseButton1Click:Connect(function()
        pcall(function()
            local char = getCharacter()
            local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
            if hrp then hrp.CFrame = CFrame.new(vec) end
        end)
    end)
end

local statusLabel = Instance.new("TextLabel", main)
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 1, -40)
statusLabel.Text = "Status: Ready"
statusLabel.BackgroundTransparency = 1
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local monitorLabel = Instance.new("TextLabel", main)
monitorLabel.Size = UDim2.new(0, 200, 0, 18)
monitorLabel.Position = UDim2.new(1, -210, 1, -40)
monitorLabel.Text = "FPS: ? | Ping: ?"
monitorLabel.BackgroundTransparency = 1
monitorLabel.TextSize = 14
monitorLabel.Font = Enum.Font.Gotham
monitorLabel.TextColor3 = Color3.fromRGB(200,200,200)
monitorLabel.TextXAlignment = Enum.TextXAlignment.Right

-- hide functionality
local hidden = false
hideBtn.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _,v in pairs(main:GetChildren()) do
        if v ~= title and v ~= hideBtn and v ~= saveBtn then
            v.Visible = not hidden
        end
    end
    if hidden then hideBtn.Text = "Show GUI" else hideBtn.Text = "Hide GUI" end
end)

-- save pos
saveBtn.MouseButton1Click:Connect(function()
    local pos = main.Position
    local x = pos.X.Offset
    local y = pos.Y.Offset
    local data = {x = x, y = y}
    pcall(function() safe_writefile(SAVE_FILE, HttpService:JSONEncode(data)) end)
    statusLabel.Text = "Status: Saved GUI Pos"
    task.delay(1.6, function() statusLabel.Text = "Status: Ready" end)
end)

-- toggles
local autoKill = false
local autoCollect = false
local autoDoor = false
local fastAttackToggle = FAST_ATTACK_ENABLED_DEFAULT

autoKillBtn.MouseButton1Click:Connect(function()
    autoKill = not autoKill
    autoKillBtn.Text = "Auto Kill: " .. (autoKill and "ON" or "OFF")
    statusLabel.Text = "Status: Auto Kill " .. (autoKill and "Enabled" or "Disabled")
end)

autoCollectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    autoCollectBtn.Text = "Auto Collect: " .. (autoCollect and "ON" or "OFF")
    statusLabel.Text = "Status: Auto Collect " .. (autoCollect and "Enabled" or "Disabled")
end)

autoDoorBtn.MouseButton1Click:Connect(function()
    autoDoor = not autoDoor
    autoDoorBtn.Text = "Auto Door: " .. (autoDoor and "ON" or "OFF")
    statusLabel.Text = "Status: Auto Door " .. (autoDoor and "Enabled" or "Disabled")
end)

fastAttackBtn.MouseButton1Click:Connect(function()
    fastAttackToggle = not fastAttackToggle
    FAST_ATTACK_ENABLED = fastAttackToggle
    fastAttackBtn.Text = "Fast Attack: " .. (FAST_ATTACK_ENABLED and "ON" or "OFF")
    statusLabel.Text = "Status: Fast Attack " .. (FAST_ATTACK_ENABLED and "Enabled" or "Disabled")
end)

-- ========== LOOPS ==========
-- Auto Kill loop (uses fast if enabled)
spawn(function()
    while true do
        if autoKill then
            local target = getNearestNPC(AUTO_ATTACK_RANGE)
            if target then
                statusLabel.Text = "Status: Attacking " .. (target.Name or "NPC")
                local part = getTargetHitbox(target)
                if part then
                    if FAST_ATTACK_ENABLED then
                        touchPartFast(part)
                        tryActivateToolFast()
                    else
                        touchPartBasic(part)
                        tryActivateTool()
                    end
                else
                    local char = getCharacter()
                    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
                    if hrp then
                        pcall(function()
                            local saved = hrp.CFrame
                            local ok, cframe = pcall(function()
                                if target.PrimaryPart then return target.PrimaryPart.CFrame end
                                local p = target:FindFirstChildWhichIsA("BasePart")
                                if p then return p.CFrame end
                                return nil
                            end)
                            if ok and cframe then
                                hrp.CFrame = cframe + Vector3.new(0, 3, 0)
                                if FAST_ATTACK_ENABLED then
                                    local p = getTargetHitbox(target) or target:FindFirstChildWhichIsA("BasePart")
                                    if p then touchPartFast(p) end
                                    tryActivateToolFast()
                                else
                                    tryActivateTool()
                                end
                                task.wait(FAST_ATTACK_ENABLED and FAST_ATTACK_COOLDOWN or ATTACK_INTERVAL)
                                hrp.CFrame = saved
                            else
                                if FAST_ATTACK_ENABLED then
                                    tryActivateToolFast()
                                else
                                    tryActivateTool()
                                end
                            end
                        end)
                    else
                        if FAST_ATTACK_ENABLED then
                            tryActivateToolFast()
                        else
                            tryActivateTool()
                        end
                    end
                end
            else
                statusLabel.Text = "Status: No target nearby"
            end
            task.wait(FAST_ATTACK_ENABLED and FAST_ATTACK_COOLDOWN or ATTACK_INTERVAL)
        else
            task.wait(0.2)
        end
    end
end)

-- Auto Collect loop
spawn(function()
    while true do
        if autoCollect then
            collectNearbyDrops()
            statusLabel.Text = "Status: Collecting drops..."
            task.wait(0.5)
        else
            task.wait(0.3)
        end
    end
end)

-- Auto Door loop
spawn(function()
    while true do
        if autoDoor then
            scanAndOpenNearbyDoors(AUTO_OPEN_RANGE)
            statusLabel.Text = "Status: Auto Door scanning..."
            task.wait(0.4)
        else
            task.wait(0.4)
        end
    end
end)

-- FPS & Ping monitor
do
    local fps = 0
    RunService.RenderStepped:Connect(function(dt)
        fps = math.floor(1/dt + 0.5)
    end)
    spawn(function()
        while true do
            local ping = "?"
            pcall(function()
                local stats = game:GetService("Stats")
                local ns = stats and stats.Network
                if ns and ns.ServerStatsItem and ns.ServerStatsItem.Ping then
                    ping = math.floor(ns.ServerStatsItem.Ping:GetValue())
                elseif ns and ns.ServerStatsItem and ns.ServerStatsItem["Data Ping"] then
                    ping = math.floor(ns.ServerStatsItem["Data Ping"]:GetValue())
                else
                    ping = "N/A"
                end
            end)
            monitorLabel.Text = ("FPS: %s | Ping: %s"):format(tostring(fps), tostring(ping))
            task.wait(1)
        end
    end)
end

-- autosave gui pos when moved
main:GetPropertyChangedSignal("Position"):Connect(function()
    local pos = main.Position
    pcall(function()
        local data = {x = pos.X.Offset, y = pos.Y.Offset}
        safe_writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end)

statusLabel.Text = "Status: Ready"
