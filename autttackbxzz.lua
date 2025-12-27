-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.7
getgenv().AutoClick = true
getgenv().ClickDelay = 0.5

-- ================= SERVICES =================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

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
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Firework Teleport"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.8, 0, 0, 40)
toggle.Position = UDim2.new(0.1, 0, 0.35, 0)
toggle.Text = "OFF"
toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.75, 0)
status.Text = "Auto Click: ON"
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(0,255,0)
status.TextScaled = true

toggle.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    if getgenv().TeleportFirework then
        toggle.Text = "ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        toggle.Text = "OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
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
