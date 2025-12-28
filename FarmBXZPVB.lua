-- ================= CONFIG =================
getgenv().TeleportFirework = false
getgenv().TeleportDelay = 0.9
getgenv().AutoClick = true
getgenv().ClickDelay = 0.2

getgenv().AutoResetEvent = true
getgenv().ResetCooldown = 3

getgenv().BackToFireworkDelay = 2
getgenv().AutoBackToFirework = true

getgenv().AutoResetOn49 = true
getgenv().FireworkFinished = false
getgenv().ResetOn49Triggered = false
getgenv().FireworkCount = 0

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
local gui = Instance.new("ScreenGui")
gui.Name = "FireworkTP_GUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 195)
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

-- ===== TELEPORT TOGGLE =====
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.85, 0, 0, 40)
toggle.Position = UDim2.new(0.075, 0, 0.22, 0)
toggle.Text = "Teleport : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
toggle.TextColor3 = Color3.fromRGB(255,255,255)
toggle.TextScaled = true
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

-- ===== RESET TOGGLE =====
local resetBtn = Instance.new("TextButton", frame)
resetBtn.Size = UDim2.new(0.85, 0, 0, 32)
resetBtn.Position = UDim2.new(0.075, 0, 0.48, 0)
resetBtn.Text = "Auto Reset : ON"
resetBtn.BackgroundColor3 = Color3.fromRGB(0,140,200)
resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
resetBtn.TextScaled = true
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 10)

-- ===== COUNTER =====
local counterLabel = Instance.new("TextLabel", frame)
counterLabel.Size = UDim2.new(1, -20, 0, 25)
counterLabel.Position = UDim2.new(0, 10, 1, -30)
counterLabel.BackgroundTransparency = 1
counterLabel.Text = "Firework: 0 / 49"
counterLabel.TextColor3 = Color3.fromRGB(255,255,0)
counterLabel.TextScaled = true

-- ================= BUTTON LOGIC =================
toggle.MouseButton1Click:Connect(function()
    getgenv().TeleportFirework = not getgenv().TeleportFirework
    if getgenv().TeleportFirework then
        getgenv().FireworkFinished = false
        toggle.Text = "Teleport : ON"
        toggle.BackgroundColor3 = Color3.fromRGB(0,180,0)
    else
        toggle.Text = "Teleport : OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(180,0,0)
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    getgenv().AutoResetEvent = not getgenv().AutoResetEvent
    resetBtn.Text = getgenv().AutoResetEvent and "Auto Reset : ON" or "Auto Reset : OFF"
end)

-- ================= DRAGGABLE =================
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

-- ================= TELEPORT TO PLOT =================
local function teleportToPlot()
    local p = workspace:FindFirstChild("Plots")
    if p and p:FindFirstChild("1") then
        HRP.CFrame = p["1"].Rows["1"].Grass["1"].CFrame + Vector3.new(0,3,0)
    end
end

-- ================= TELEPORT FIREWORK LOOP =================
task.spawn(function()
    while task.wait(0.2) do
        if not getgenv().TeleportFirework then continue end

        local sm = workspace:FindFirstChild("ScriptedMap")
        if not sm or not sm:FindFirstChild("SpawnedFireworks") then continue end

        for i = 1, 49 do
            if not getgenv().TeleportFirework then break end

            local fw = sm.SpawnedFireworks:FindFirstChild(tostring(i))
            if fw and fw:FindFirstChild("Rocket") then
                local part = fw.Rocket:FindFirstChild("MainColor")
                if part then
                    getgenv().FireworkCount = i
                    counterLabel.Text = "Firework: "..i.." / 49"
                    HRP.CFrame = part.CFrame + Vector3.new(0,3,0)
                    task.wait(getgenv().TeleportDelay)

                    -- ===== AUTO RESET DI 49 =====
                    if i == 49 and getgenv().AutoResetOn49 and not getgenv().ResetOn49Triggered then
                        getgenv().ResetOn49Triggered = true
                        getgenv().TeleportFirework = false
                        toggle.Text = "Teleport : OFF"
                        toggle.BackgroundColor3 = Color3.fromRGB(180,0,0)

                        teleportToPlot()

                        -- Trigger reset prompt
                        task.spawn(function()
                            task.wait(0.5)
                            local ny = sm:FindFirstChild("NewYears2026")
                            if ny then
                                local prompt = ny:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then pcall(function() fireproximityprompt(prompt) end) end
                            end
                        end)

                        -- Auto balik lagi
                        task.delay(getgenv().BackToFireworkDelay, function()
                            getgenv().ResetOn49Triggered = false
                            getgenv().FireworkCount = 0
                            counterLabel.Text = "Firework: 0 / 49"
                            getgenv().TeleportFirework = true
                            toggle.Text = "Teleport : ON"
                            toggle.BackgroundColor3 = Color3.fromRGB(0,180,0)
                        end)

                        break
                    end
                end
            end
        end
    end
end)
