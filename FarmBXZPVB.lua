-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7

getgenv().AutoClick = false
getgenv().ClickDelay = 0.3 -- default 300 ms

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
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
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "FireworkGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 210)
frame.Position = UDim2.new(0.05, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Firework Control"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- ===== TELEPORT TOGGLE =====
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.9,0,0,40)
tpBtn.Position = UDim2.new(0.05,0,0.2,0)
tpBtn.Text = "Teleport : OFF"
tpBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.TextScaled = true
Instance.new("UICorner", tpBtn)

tpBtn.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    tpBtn.Text = getgenv().TeleportFirework and "Teleport : ON" or "Teleport : OFF"
    tpBtn.BackgroundColor3 = getgenv().TeleportFirework and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
end)

-- ===== AUTO CLICK TOGGLE =====
local acBtn = Instance.new("TextButton", frame)
acBtn.Size = UDim2.new(0.9,0,0,40)
acBtn.Position = UDim2.new(0.05,0,0.42,0)
acBtn.Text = "Auto Click : OFF"
acBtn.BackgroundColor3 = Color3.fromRGB(180,0,0)
acBtn.TextColor3 = Color3.new(1,1,1)
acBtn.TextScaled = true
Instance.new("UICorner", acBtn)

acBtn.MouseButton1Click:Connect(function()
    getgenv().AutoClick = not getgenv().AutoClick
    acBtn.Text = getgenv().AutoClick and "Auto Click : ON" or "Auto Click : OFF"
    acBtn.BackgroundColor3 = getgenv().AutoClick and Color3.fromRGB(0,180,0) or Color3.fromRGB(180,0,0)
end)

-- ===== INPUT DELAY =====
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9,0,0,35)
box.Position = UDim2.new(0.05,0,0.65,0)
box.PlaceholderText = "Delay Auto Click (ms / s)"
box.Text = "0.3"
box.BackgroundColor3 = Color3.fromRGB(50,50,50)
box.TextColor3 = Color3.new(1,1,1)
box.TextScaled = true
Instance.new("UICorner", box)

box.FocusLost:Connect(function()
    local v = tonumber(box.Text)
    if v and v > 0 then
        if v > 1 then
            getgenv().ClickDelay = v / 1000 -- ms ke detik
        else
            getgenv().ClickDelay = v
        end
    end
    box.Text = tostring(getgenv().ClickDelay)
end)

-- ================= DRAGGABLE =================
local dragging, dragStart, startPos = false

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ================= AUTO CLICK LOOP =================
task.spawn(function()
    while task.wait(0.05) do
        if getgenv().AutoClick then
            task.wait(getgenv().ClickDelay)
            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.03)
            VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
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
                        if part then
                            HRP.CFrame = part.CFrame + Vector3.new(0,3,0)
                            task.wait(getgenv().TeleportDelay)
                        end
                    end
                end
            end
        end
    end
end)
