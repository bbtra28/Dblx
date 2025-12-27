-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7
getgenv().AutoClick = true
getgenv().ClickDelay = 0.5

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
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
    if getgenv().TeleportFirework then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,180,0)
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
    end
end)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1, 0, 0, 25)
info.Position = UDim2.new(0, 0, 0.75, 0)
info.Text = "Auto Click: 0.5s"
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(0,255,0)
info.TextScaled = true

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
                            HRP.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            task.wait(getgenv().TeleportDelay)
                        end
                    end
                end
            end
        end
    end
end)
