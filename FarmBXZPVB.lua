-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7

getgenv().AutoClick = false
getgenv().ClickDelay = 0.5

-- ================= SERVICES =================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ================= CHARACTER =================
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Character = getChar()
local HRP = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkTP_GUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 220)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Firework TP FINAL"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true

-- ================= TP TOGGLE =================
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.8, 0, 0, 40)
tpBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
tpBtn.Text = "TP : OFF"
tpBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.TextScaled = true
Instance.new("UICorner", tpBtn)

tpBtn.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    if getgenv().TeleportFirework then
        tpBtn.Text = "TP : ON"
        tpBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        tpBtn.Text = "TP : OFF"
        tpBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)

-- ================= AUTO CLICK TOGGLE =================
local acBtn = Instance.new("TextButton", frame)
acBtn.Size = UDim2.new(0.8, 0, 0, 40)
acBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
acBtn.Text = "AUTO CLICK : OFF"
acBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
acBtn.TextColor3 = Color3.fromRGB(255,255,255)
acBtn.TextScaled = true
Instance.new("UICorner", acBtn)

acBtn.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    if getgenv().AutoClick then
        acBtn.Text = "AUTO CLICK : ON"
        acBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        acBtn.Text = "AUTO CLICK : OFF"
        acBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)

-- ================= CLICK DELAY INPUT =================
local delayBox = Instance.new("TextBox", frame)
delayBox.Size = UDim2.new(0.8, 0, 0, 35)
delayBox.Position = UDim2.new(0.1, 0, 0.75, 0)
delayBox.PlaceholderText = "Click Delay (ex: 0.5)"
delayBox.Text = tostring(getgenv().ClickDelay)
delayBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
delayBox.TextColor3 = Color3.fromRGB(255,255,255)
delayBox.TextScaled = true
Instance.new("UICorner", delayBox)

delayBox.FocusLost:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v > 0 then
        getgenv().ClickDelay = v
    else
        delayBox.Text = tostring(getgenv().ClickDelay)
    end
end)

-- ================= TELEPORT LOOP =================
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().TeleportFirework then
            for i = 1, 50 do
                if not getgenv().TeleportFirework then break end

                local sm = workspace:FindFirstChild("ScriptedMap")
                if sm and sm:FindFirstChild("SpawnedFireworks") then
                    local fw = sm.SpawnedFireworks:FindFirstChild(tostring(i))
                    if fw and fw:FindFirstChild("Rocket") then
                        local part = fw.Rocket:FindFirstChild("MainColor")
                        if part and part:IsA("BasePart") then
                            HRP.CFrame = part.CFrame + Vector3.new(0,3,0)
                            task.wait(getgenv().TeleportDelay)
                        end
                    end
                end
            end
        end
    end
end)

-- ================= AUTO CLICK LOOP (MOUSE) =================
task.spawn(function()
    while task.wait() do
        if getgenv().AutoClick then
            pcall(function()
                Mouse:Click()
            end)
            task.wait(getgenv().ClickDelay)
        end
    end
end)
