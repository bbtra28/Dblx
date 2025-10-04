-- Auto Attack / Auto Kill - Generic
-- Jalankan di executor. Pastikan Entities ada di workspace.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

-- GUI status (agar tidak perlu console)
local function makeLabel()
    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "AutoAttackGUI"
    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1,0,0,40)
    label.Position = UDim2.new(0,0,0,0)
    label.BackgroundTransparency = 0.6
    label.TextScaled = true
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundColor3 = Color3.new(0,0,0)
    label.Text = "AutoAttack: Idle"
    return label
end

local statusLabel = makeLabel()

local autoAttackEnabled = false
local attackRange = 300
local attemptRemotes = {
    "Attack", "AttackEvent", "Damage", "Hit", "MeleeEvent", "Combat",
    "ByteNetReliable", "RemoteAttack", "HitEvent", "Skill", "DealDamage"
}

local function tryCallRemote(remote, args)
    local ok, err = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
            return true
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(args))
            return true
        end
    end)
    return ok and not err
end

local function findRemotes()
    local found = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(found, v)
        end
    end
    return found
end

local function getEntityFolder()
    return workspace:FindFirstChild("Entities")
end

local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear)

local function smoothTeleportTo(cframe)
    pcall(function()
        local tween = TweenService:Create(HRP, tweenInfo, {CFrame = cframe})
        Humanoid.PlatformStand = true
        tween:Play()
        tween.Completed:Wait()
        Humanoid.PlatformStand = false
    end)
end

local function tryUseToolOnTarget(targetModel)
    -- coba equip tool dari Backpack atau Character
    local tool = nil
    if Character then
        for _, t in pairs(Character:GetChildren()) do
            if t:IsA("Tool") then tool = t break end
        end
    end
    if not tool then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, t in pairs(backpack:GetChildren()) do
                if t:IsA("Tool") then tool = t break end
            end
        end
    end
    if tool then
        pcall(function()
            LocalPlayer.Character.Humanoid:EquipTool(tool)
            -- teleport close
            if targetModel and targetModel:FindFirstChild("HumanoidRootPart") then
                local pos = targetModel.HumanoidRootPart.Position
                smoothTeleportTo(CFrame.new(pos + Vector3.new(0,7,0)))
            end
            -- Some tools respond to :Activate() on client (may or may not work)
            if tool.Activate then
                tool:Activate()
            end
            -- Try firing remote inside tool if any
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    pcall(function() if child:IsA("RemoteEvent") then child:FireServer(targetModel) else child:InvokeServer(targetModel) end end)
                end
            end
        end)
        return true
    end
    return false
end

local function buildArgVariants(target)
    local args = {}
    local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Root") or target.PrimaryPart
    -- common variants
    table.insert(args, {target.Name})
    table.insert(args, {target})
    if root then
        table.insert(args, {root})
        table.insert(args, {root.Position})
        table.insert(args, {root.CFrame})
    end
    table.insert(args, {target.Name, root and root.Position or nil})
    return args
end

local function findNearestEntity(range)
    local folder = getEntityFolder()
    if not folder then return nil end
    local best, bestDist = nil, math.huge
    for _, m in pairs(folder:GetChildren()) do
        if m:IsA("Model") and m:FindFirstChild("HumanoidRootPart") then
            local hum = m:FindFirstChildOfClass("Humanoid")
            if not hum or (hum and hum.Health > 0) then
                local dist = (HRP.Position - m.HumanoidRootPart.Position).Magnitude
                if dist < bestDist and dist <= range then
                    bestDist = dist
                    best = m
                end
            end
        end
    end
    return best, bestDist
end

local function attackLoop()
    statusLabel.Text = "AutoAttack: Running"
    local knownRemotes = findRemotes() -- daftar remotes yang tersedia untuk dipakai
    while autoAttackEnabled do
        local target = findNearestEntity(attackRange)
        if not target then
            statusLabel.Text = "AutoAttack: No entities in range"
            task.wait(1)
            continue
        end

        statusLabel.Text = "Target: "..tostring(target.Name)
        -- teleport sedikit di atas target supaya serangan lebih mungkin kena
        if target:FindFirstChild("HumanoidRootPart") then
            local pos = target.HumanoidRootPart.Position
            smoothTeleportTo(CFrame.new(pos + Vector3.new(0,8,0)))
            task.wait(0.15)
        end

        -- pertama coba tools (jika ada)
        local usedTool = tryUseToolOnTarget(target)
        if usedTool then
            statusLabel.Text = "Tried tool on "..tostring(target.Name)
            task.wait(0.3)
        end

        -- siapkan varian argumen umum
        local argVariants = buildArgVariants(target)

        -- coba remotes yang ada di game namun mungkin bernama lain
        local didAnything = false
        -- coba remotes yang sudah ditemukan di game
        for _, r in pairs(knownRemotes) do
            for _, a in pairs(argVariants) do
                local ok, err = pcall(function()
                    if r:IsA("RemoteEvent") then
                        r:FireServer(unpack(a))
                    else
                        r:InvokeServer(unpack(a))
                    end
                end)
                if ok then
                    didAnything = true
                    statusLabel.Text = "Fired remote "..r:GetFullName()
                    task.wait(0.12)
                end
            end
        end

        -- juga coba beberapa nama remote yang umum walau tidak direplika ke client (failsafe)
        for _, name in pairs(attemptRemotes) do
            local maybe = ReplicatedStorage:FindFirstChild(name) or workspace:FindFirstChild(name) or game:FindFirstChild(name)
            if maybe and (maybe:IsA("RemoteEvent") or maybe:IsA("RemoteFunction")) then
                for _, a in pairs(argVariants) do
                    pcall(function()
                        if maybe:IsA("RemoteEvent") then maybe:FireServer(unpack(a)) else maybe:InvokeServer(unpack(a)) end
                    end)
                    didAnything = true
                    task.wait(0.1)
                end
            end
        end

        if not didAnything then
            statusLabel.Text = "No usable remote/tool found; teleport+wait"
            task.wait(0.5)
            -- try short attack pulses via local animation: attempt to swing by toggling Humanoid states quickly
            pcall(function()
                Humanoid:LoadAnimation(Instance.new("Animation"))
            end)
        end

        task.wait(0.25)
    end
    statusLabel.Text = "AutoAttack: Stopped"
end

-- Public toggles
print("AutoAttack script loaded. Use ToggleAutoAttack() to start/stop.")
function ToggleAutoAttack()
    autoAttackEnabled = not autoAttackEnabled
    if autoAttackEnabled then
        task.spawn(attackLoop)
    end
    return autoAttackEnabled
end

-- Also expose quick start
-- ToggleAutoAttack() -- uncomment to auto-start
