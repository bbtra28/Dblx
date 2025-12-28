-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7
getgenv().AutoClick = true
getgenv().ClickDelay = 0.3
getgenv().AutoTeleportResetPrompt = true

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LocalPlayer = Players.LocalPlayer

-- ================= CHARACTER =================
local function setupChar()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char, char:WaitForChild("HumanoidRootPart")
end

local Character, HRP = setupChar()
LocalPlayer.CharacterAdded:Connect(function()
    Character, HRP = setupChar()
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkTP_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Firework Teleport"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.85, 0, 0, 45)
toggle.Position = UDim2.new(0.075, 0, 0.35, 0)
toggle.Text = "OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

toggle.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    toggle.Text = getgenv().TeleportFirework and "ON" or "OFF"
    toggle.BackgroundColor3 = getgenv().TeleportFirework
        and Color3.fromRGB(0,180,0)
        or Color3.fromRGB(180,0,0)
end)

-- ================= AUTO CLICK =================
task.spawn(function()
    while task.wait(getgenv().ClickDelay) do
        if getgenv().TeleportFirework and getgenv().AutoClick then
            pcall(function()
                VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(0.05)
                VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        end
    end
end)

-- ================= FIREWORK DETECTION =================
local function isFireworkDestroyed(part)
    if not part then return true end
    if not part.Parent then return true end
    if part.Transparency >= 1 then return true end
    if part.Size.Magnitude <= 0 then return true end
    return false
end

-- ================= FIND RESET PROMPT =================
local function findResetPrompt()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if string.find(obj.Name:lower(), "reset")
            or string.find(obj.ActionText:lower(), "reset") then
                return obj
            end
        end
    end
end

-- ================= TELEPORT TO PROMPT =================
local function teleportToPrompt(prompt)
    if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
        HRP.CFrame = prompt.Parent.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.2)
    end
end

-- ================= TELEPORT LOOP =================
local fireworkIndex = 1
local MAX_FIREWORK = 50

task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().TeleportFirework then continue end

        local sm = workspace:FindFirstChild("ScriptedMap")
        if not sm then continue end

        local sf = sm:FindFirstChild("SpawnedFireworks")
        if not sf then continue end

        local fw = sf:FindFirstChild(tostring(fireworkIndex))
        if fw and fw:FindFirstChild("Rocket") then
            local part = fw.Rocket:FindFirstChild("MainColor")

            if part and part:IsA("BasePart") then
                HRP.CFrame = part.CFrame + Vector3.new(0, 3, 0)

                local t = 0
                while t < getgenv().TeleportDelay do
                    if isFireworkDestroyed(part) then
                        -- 🔴 JIKA HANCUR → CARI PROMPT RESET
                        if getgenv().AutoTeleportResetPrompt then
                            local prompt = findResetPrompt()
                            if prompt then
                                teleportToPrompt(prompt)
                            end
                        end
                        break
                    end
                    t += 0.05
                    task.wait(0.05)
                end
            end
        end

        fireworkIndex += 1
        if fireworkIndex > MAX_FIREWORK then
            fireworkIndex = 1
            task.wait(0.3)
        end
    end
end)
